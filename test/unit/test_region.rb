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

class TestRegion < Test::Unit::TestCase
  include Nasl::Test

  def test_conditional_statements
    block = "{ a(); b(); } \n\n "
    assignment = "a = 2 \n  "
    semicolon =  "; \n   "

    condition = "for (i = 1; i < 0; ++i) \n   \n "
    code = [condition, block, assignment, semicolon].join
    tree = parse(code)
    assert_not_nil(tree)
    assert_equal(block, code[tree.all(:Block)[0].region])
    assert_equal("i = 1", code[tree.all(:Assignment)[0].region])
    assert_equal(assignment, code[tree.all(:Assignment)[1].region])
    assert_equal(condition + block, code[tree.all(:For)[0].region])

    condition = "while (i < 0) \n   \n "
    code = [condition, block, assignment, semicolon].join
    tree = parse(code)
    assert_not_nil(tree)
    assert_equal(condition + block, code[tree.all(:While)[0].region])

    condition = "foreach a (b) \n   \n "
    code = [condition, block, assignment, semicolon].join
    tree = parse([condition, block, assignment, semicolon].join)
    assert_not_nil(tree)
    assert_equal(condition + block, code[tree.all(:Foreach)[0].region])
  end

  def test_assignments
    assignments = [
      "a =  \n 1",
      "a.b['c']\n=\n'this' + \n'is' + \n 'a multiline' + \n 'string  '",
      "a = hello()",
      "a = 'string with space after it'   ",
      "a = 1"
    ]

    code = assignments.join(";") + ";"
    tree = parse(code)

    assignments.each_with_index do |orig_fragment, index|
      assert_equal(orig_fragment, code[tree.all(:Assignment)[index].region])
    end
  end
end
