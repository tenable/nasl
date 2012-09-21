$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'bundler/gem_tasks'
require 'rake'
require 'rake/clean'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
end

rule(%r{\.tab\.rb$} => lambda { |f| f.sub(/\.tab.rb/, '.racc') }) do |t|
  sh "racc #{t.source}"
end

desc "Generate grammar modules from Racc source."
task :grammars => FileList['**/*.racc'].ext('.tab.rb')

desc "Produce a fully-functional application."
task :compile => [:grammars, :test]

task :build => :compile do
  system "gem build nasl.gemspec"
end

task :default => :compile
