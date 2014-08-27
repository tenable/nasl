################################################################################
# Copyright (c) 2011-2014, Tenable Network Security
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

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

task :tag_and_bag do
	system "git tag -a v#{Nasl::VERSION} -m 'version #{Nasl::VERSION}'"
	system "git push --tags"
	system "git checkout master"
	#system "git merge #{Nasl::VERSION}"
	system "git push"
end

task :release => [:tag_and_bag, :build] do
 	system "gem push #{Nasl::APP_NAME}-#{Nasl::VERSION}.gem"
end

task :default => :compile
