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

class TestNamespace < Test::Unit::TestCase
  include Nasl::Test

  def test_namespace
    tree = parse("namespace foo {}")
    assert_not_nil(tree)

    namespaces = tree.all(:Namespace)
    assert_not_nil(namespaces)
    assert_equal(1, namespaces.length)
  end

  def test_nested_namespace
    tree = parse("namespace foo {namespace bar {}}")
    assert_not_nil(tree)

    namespaces = tree.all(:Namespace)
    assert_not_nil(namespaces)
    assert_equal(2, namespaces.length)
  end

  def test_namespace_with_function
    tree = parse("namespace foo {function bar() {}}")
    assert_not_nil(tree)

    functions = tree.all(:Function)
    assert_not_nil(functions)
    assert_equal(1, functions.length)
  end

  def test_namespace_with_global
    tree = parse("namespace foo {global_var bar = 1;}")
    assert_not_nil(tree)

    globals = tree.all(:Global)
    assert_not_nil(globals)
    assert_equal(1, globals.length)
  end
end
