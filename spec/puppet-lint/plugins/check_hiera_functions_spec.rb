# frozen_string_literal: true

require 'spec_helper'

describe 'hiera_functions' do
  let(:msg) { 'function is deprecated.  Use lookup()' }

  context 'with fix disabled' do
    context 'with hiera function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera('test-key-name')
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems.size).to eq(1)
      end

      it 'creates warnings' do
        expect(problems).to contain_warning("hiera #{msg}").on_line(2).in_column(23)
      end
    end

    context 'with hiera_array function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera_array('test-key-name')
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems.size).to eq(1)
      end

      it 'creates warnings' do
        expect(problems).to contain_warning("hiera_array #{msg}").on_line(2).in_column(23)
      end
    end

    context 'with hiera_hash function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera_hash('test-key-name')
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems.size).to eq(1)
      end

      it 'creates warnings' do
        expect(problems).to contain_warning("hiera_hash #{msg}").on_line(2).in_column(23)
      end
    end

    context 'with hiera_include function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera_include('test-key-name')
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems.size).to eq(1)
      end

      it 'creates warnings' do
        expect(problems).to contain_warning("hiera_include #{msg}").on_line(2).in_column(23)
      end
    end
  end

  context 'with fix enabled' do
    before(:each) do
      PuppetLint.configuration.fix = true
    end

    after(:each) do
      PuppetLint.configuration.fix = false
    end

    context 'with hiera function' do
      let(:code) do
        <<-PP
        class function_tester {
          $hiera = hiera('test-key-name')
        }
        PP
      end

      let(:fixed_code) do
        <<-PP
        class function_tester {
          $hiera = lookup('test-key-name')
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems).to contain_fixed("hiera #{msg}").on_line(2)
      end

      it 'changes hiera to lookup' do
        expect(manifest).to eq(fixed_code)
      end
    end

    context 'with hiera_array function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera_array('test-key-name')
        }
        PP
      end

      let(:fixed_code) do
        <<-PP
        class function_tester {
          $test_key = lookup('test-key-name', {merge => unique})
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems).to contain_fixed("hiera_array #{msg}").on_line(2)
      end

      it 'changes hiera to lookup' do
        expect(manifest).to eq(fixed_code)
      end
    end

    context 'with hiera_hash function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera_hash('test-key-name')
        }
        PP
      end

      let(:fixed_code) do
        <<-PP
        class function_tester {
          $test_key = lookup('test-key-name', {merge => hash})
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems).to contain_fixed("hiera_hash #{msg}").on_line(2)
      end

      it 'changes hiera to lookup' do
        expect(manifest).to eq(fixed_code)
      end
    end

    context 'with hiera_include function' do
      let(:code) do
        <<-PP
        class function_tester {
          $test_key = hiera_include('test-key-name')
        }
        PP
      end

      let(:fixed_code) do
        <<-PP
        class function_tester {
          $test_key = lookup('test-key-name', {merge => unique}).include
        }
        PP
      end

      it 'detects a single problem' do
        expect(problems).to contain_fixed("hiera_include #{msg}").on_line(2)
      end

      it 'changes hiera to lookup' do
        expect(manifest).to eq(fixed_code)
      end
    end
  end
end
