################################################################################
# Copyright (c) 2011, Mak Kolybabi
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

require 'nasl/parser'
require 'test/unit'

module Nasl
  module Test
    def self.initialize!(args)
      # Run all tests by default.
      args = ['unit/*', 'unit/*/*'] if args.empty?

      # Run each test or category of tests specified on the command line.
      args.each do |test|
        Dir.glob(Nasl.test + (test + '.rb')).each { |f| load(f) }
      end
    end

    def flatten(tree)
      tree.chomp.split(/\n/).map(&:strip).join
    end

    def parse(code)
      begin
        tree = Nasl::Parser.new.parse(code)
        msg = ''
      rescue Racc::ParseError => e
        tree = nil
        msg = e
      end

      return tree, msg
    end

    def tokenize(code)
      Nasl::Tokenizer.new(code, "(test)")
    end

    def context(code)
      Nasl::Context.new(code, "(test)")
    end

    def fail(code)
      tree, msg = parse(code)

      assert_nil(tree, msg)
    end

    def fail_parse(code)
      assert_raise(ParseException) { Nasl::Parser.new.parse(code) }
    end

    def fail_token(code)
      assert_raise(TokenException) { Nasl::Parser.new.parse(code) }
    end

    def pass(code)
      tree, msg = parse(code)

      assert_not_nil(tree, msg)
    end

    def diff(code, kg_tree)
      tree, msg = parse(code)
      assert_not_nil(tree, msg)
      assert_not_equal(flatten(kg_tree), flatten(tree.to_s)) if !tree.nil?
    end

    def same(code, kg_tree)
      tree, msg = parse(code)
      assert_not_nil(tree, msg)
      assert_equal(flatten(kg_tree), flatten(tree.to_s)) if !tree.nil?
    end
  end
end
