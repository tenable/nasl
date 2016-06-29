################################################################################
# Copyright (c) 2016, Tenable Network Security
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

class TestObject < Test::Unit::TestCase
  include Nasl::Test

  def test_object
    tree = parse("object foo {}")
    assert_not_nil(tree)

    objects = tree.all(:Object)
    assert_not_nil(objects)
    assert_equal(1, objects.length)
  end

  def test_object_with_function
    tree = parse("object foo {function bar() {}}")
    assert_not_nil(tree)

    functions = tree.all(:Function)
    assert_not_nil(functions)
    assert_equal(1, functions.length)
  end

  def test_object_with_var
    tree = parse("object foo {var bar;}")
    assert_not_nil(tree)

    vars = tree.all(:Var)
    assert_not_nil(vars)
    assert_equal(1, vars.length)
  end

  def test_object_with_var_init
    tree = parse("object foo {var bar = 1;}")
    assert_not_nil(tree)

    vars = tree.all(:Var)
    assert_not_nil(vars)
    assert_equal(1, vars.length)
  end

  def test_object_in_namespace
    tree = parse("namespace foo {object bar {}}")
    assert_not_nil(tree)

    objects = tree.all(:Object)
    assert_not_nil(objects)
    assert_equal(1, objects.length)
  end

  def test_object_fail_not_var_or_func
    fail_parse("object foo{display('foo!');}")
    fail_parse("object foo{while(1){}}")
  end
end
