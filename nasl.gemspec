# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nasl/version"

Gem::Specification.new do |s|
  s.name        = "nasl"
  s.version     = Nasl::VERSION
  s.authors     = ["Stefan Penner"]
  s.email       = ["stefan.penner@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "nasl"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'

  s.add_runtime_dependency 'builder'
  s.add_runtime_dependency 'rex'
  s.add_runtime_dependency 'racc'
end
