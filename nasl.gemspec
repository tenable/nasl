# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'nasl/version'

Gem::Specification.new do |s|
  s.name        = 'nasl'
  s.version     = Nasl::VERSION
  s.license     = "BSD"
  s.homepage    = 'http://github.com/tenable/nasl'
  s.summary     = 'A parser for the Nessus Attack Scripting Language.'
  s.description = File.open('README.md').read

  s.authors     = ['Mak Kolybabi']
  s.email       = ['mak@kolybabi.com']

  s.rubyforge_project = 'nasl'

  s.files         = `git ls-files`.split("\n") + Dir.glob('**/*.tab.rb')
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'racc'
  s.add_development_dependency 'rake'

  s.add_runtime_dependency 'builder'
  s.add_runtime_dependency 'rainbow'
end
