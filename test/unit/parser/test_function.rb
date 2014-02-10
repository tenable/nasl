################################################################################
# Copyright (c) 2011-2014, Mak Kolybabi
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

class TestFunction < Test::Unit::TestCase
  include Nasl::Test

  def test_keyword_prefix
    # We never want to have a function with the same name as a keyword.
    fail_parse("function break() {}")
    fail_parse("function continue() {}")
    fail_parse("function else() {}")
    fail_parse("function export() {}")
    fail_parse("function for() {}")
    fail_parse("function foreach() {}")
    fail_parse("function function() {}")
    fail_parse("function global_var() {}")
    fail_parse("function if() {}")
    fail_parse("function import() {}")
    fail_parse("function include() {}")
    fail_parse("function local_var() {}")
    fail_parse("function repeat() {}")
    fail_parse("function return() {}")
    fail_parse("function until() {}")
    fail_parse("function while() {}")

    # We never want to have a function with the same name as a constant.
    fail_parse("function FALSE() {}")
    fail_parse("function NULL() {}")
    fail_parse("function TRUE() {}")

    # 'in' and 'x' are exceptions. They are valid function names, despite being a keywords.
    pass("function in() {}")
    pass("function x() {}")

    # Having a keyword at the start of a function name is perfectly valid.
    pass("function break_() {}")
    pass("function continue_() {}")
    pass("function else_() {}")
    pass("function export_() {}")
    pass("function for_() {}")
    pass("function foreach_() {}")
    pass("function function_() {}")
    pass("function global_var_() {}")
    pass("function if_() {}")
    pass("function import_() {}")
    pass("function include_() {}")
    pass("function local_var_() {}")
    pass("function repeat_() {}")
    pass("function return_() {}")
    pass("function until_() {}")
    pass("function while_() {}")

    # Having a constant at the start of a function name is perfectly valid.
    pass("function FALSE_() {}")
    pass("function NULL_() {}")
    pass("function TRUE_() {}")
  end

  def test_no_args
    tree = parse("function foo() {}")
    assert_not_nil(tree)

    funcs = tree.all(:Function)
    assert_not_nil(funcs)
    assert_equal(1, funcs.length)

    func = funcs.first
    assert_not_nil(func)
    assert_equal(0, func.params.length)
  end

  def test_named_args
    tree = parse("function foo(a, b, c) {}")
    assert_not_nil(tree)

    funcs = tree.all(:Function)
    assert_not_nil(funcs)
    assert_equal(1, funcs.length)

    func = funcs.first
    assert_not_nil(func)
    assert_equal(3, func.params.length)

    param = func.params[0]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'a')
    assert_equal(param.pass_by, 'value')

    param = func.params[1]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'b')
    assert_equal(param.pass_by, 'value')

    param = func.params[2]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'c')
    assert_equal(param.pass_by, 'value')
  end

  def test_reference_args
    tree = parse("function foo(&a, &b, &c) {}")
    assert_not_nil(tree)

    funcs = tree.all(:Function)
    assert_not_nil(funcs)
    assert_equal(1, funcs.length)

    func = funcs.first
    assert_not_nil(func)
    assert_equal(3, func.params.length)

    param = func.params[0]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'a')
    assert_equal(param.pass_by, 'reference')

    param = func.params[1]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'b')
    assert_equal(param.pass_by, 'reference')

    param = func.params[2]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'c')
    assert_equal(param.pass_by, 'reference')
  end

  def test_mixed_args
    tree = parse("function foo(a, &b, c) {}")
    assert_not_nil(tree)

    funcs = tree.all(:Function)
    assert_not_nil(funcs)
    assert_equal(1, funcs.length)

    func = funcs.first
    assert_not_nil(func)
    assert_equal(3, func.params.length)

    param = func.params[0]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'a')
    assert_equal(param.pass_by, 'value')

    param = func.params[1]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'b')
    assert_equal(param.pass_by, 'reference')

    param = func.params[2]
    assert(param.is_a? Nasl::Parameter)
    assert_equal(param.name.name, 'c')
    assert_equal(param.pass_by, 'value')
  end
end
