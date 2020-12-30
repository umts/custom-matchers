# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rdoc/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.markup = 'markdown'
  rdoc.rdoc_files.include('README.md', 'lib')
  rdoc.rdoc_dir = 'docs'
end

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: :spec
