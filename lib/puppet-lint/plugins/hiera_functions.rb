# frozen_string_literal: true

# Checks manifests for deprecated Hiera functions
# hiera(), hiera_arrya(), hiera_hash() and hiera_include()
#
# @see https://www.puppet.com/docs/puppet/8/hiera_migrate.html
#
PuppetLint.new_check(:hiera_functions) do
  def check
    # Get all the functions.  The function_index in puppet-lint is supposed to do this,
    # but it was always empty when I tried to use it
    function_tokens = tokens.select { |token| token.type == :FUNCTION_NAME }

    # Check each function for matching the hiera function list.
    function_tokens.each do |function_token|
      next unless function_token.value.match?(%r{^hiera(|_array|_hash|_include)$})

      notify(
        :warning,
        message: "#{function_token.value} function is deprecated.  Use lookup()",
        line: function_token.line,
        column: function_token.column,
        token: function_token,
      )
    end
  end

  # Attempt the fix
  #
  # hiera('key')         -> lookup('key')
  # hiera_array('key')   -> lookup('key', {merge => unique})
  # hiera_hash('key')    -> lookup('key', {merge => hash})
  # hiera_include('key') -> lookup('key', {merge => unique}).include
  #
  def fix(problem)
    case problem[:token].value
    when 'hiera_array'
      fix_hiera_with_merge(problem, 'unique')
    when 'hiera_include'
      fix_hiera_with_merge(problem, 'unique')
      fix_hiera_append_include(problem)
    when 'hiera_hash'
      fix_hiera_with_merge(problem, 'hash')
    end

    # Always swap hiera() for lookup()
    problem[:token].value = 'lookup'
  end

  private

  def fix_hiera_with_merge(problem, merge_type)
    index = tokens.index(problem[:token].next_token_of(:LPAREN).next_token_of(:RPAREN))

    # Add the necessary tokens to the end in reverse order, so the index doesn't change =)
    add_token(index, PuppetLint::Lexer::Token.new(:RBRACE, '}', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:NAME, merge_type, 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:WHITESPACE, ' ', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:FARROW, '=>', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:WHITESPACE, ' ', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:NAME, 'merge', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:LBRACE, '{', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:WHITESPACE, ' ', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:COMMA, ',', 0, 0))
  end

  def fix_hiera_append_include(problem)
    # Get the index of the token _past_ the right paren
    index = tokens.index(problem[:token].next_token_of(:LPAREN).next_token_of(:RPAREN)) + 1

    # Add the tokens in reverse order so the index doesn't change
    add_token(index, PuppetLint::Lexer::Token.new(:NAME, 'include', 0, 0))
    add_token(index, PuppetLint::Lexer::Token.new(:DOT, '.', 0, 0))
  end
end
