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

# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)

require 'nasl/version'

Gem::Specification.new do |s|
  s.name        = 'nasl'
  s.version     = Nasl::VERSION
  s.license     = 'BSD'
  s.homepage    = 'http://github.com/tenable/nasl'
  s.summary     = 'A language parser for the Nessus Attack Scripting Language.'
  s.description = 'A language parser for the Nessus Attack Scripting Language. Supporting NASL v5.2.'

  s.authors     = ['Mak Kolybabi', 'Alex Weber', 'Jacob Hammack']
  s.email       = ['mak@kolybabi.com', 'aweber@tenble.com', 'jhammack@tenable.com']

  s.rubyforge_project = 'nasl'

  s.files         = `git ls-files`.split("\n") + Dir.glob('**/*.tab.rb')
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'racc', '~>1.4'
  s.add_development_dependency 'rake', '~>10.1'

  s.add_runtime_dependency 'builder', '~> 3.1'
  s.add_runtime_dependency 'rainbow', '~> 2.0'
end
