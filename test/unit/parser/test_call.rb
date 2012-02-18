################################################################################
# Copyright (c) 2011-2012, Mak Kolybabi
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

class TestCall < Test::Unit::TestCase
  include Nasl::Test

  def test_no_args
    tree = parse("foo();")
    assert_not_nil(tree)

    calls = tree.all(:Call)
    assert_not_nil(calls)
    assert_equal(1, calls.length)

    call = calls.first
    assert_not_nil(call)
    assert_equal(0, call.args.length)
  end

  def test_anonymous_args
    tree = parse("foo(1, '2', three);")
    assert_not_nil(tree)

    calls = tree.all(:Call)
    assert_not_nil(calls)
    assert_equal(1, calls.length)

    call = calls.first
    assert_not_nil(call)
    assert_equal(3, call.args.length)

    arg = call.args[0]
    assert_equal(:anonymous, arg.type)
    assert(arg.expr.is_a? Nasl::Integer)

    arg = call.args[1]
    assert_equal(:anonymous, arg.type)
    assert(arg.expr.is_a? Nasl::String)

    arg = call.args[2]
    assert_equal(:anonymous, arg.type)
    assert(arg.expr.is_a? Nasl::Lvalue)
  end

  def test_named_args
    tree = parse("foo(a:1, b:'2', c:three);")
    assert_not_nil(tree)

    calls = tree.all(:Call)
    assert_not_nil(calls)
    assert_equal(1, calls.length)

    call = calls.first
    assert_not_nil(call)
    assert_equal(3, call.args.length)

    arg = call.args[0]
    assert_equal(:named, arg.type)
    assert(arg.name.is_a? Nasl::Identifier)
    assert(arg.expr.is_a? Nasl::Integer)
    assert_equal(arg.expr, call.arg['a'])

    arg = call.args[1]
    assert_equal(:named, arg.type)
    assert(arg.name.is_a? Nasl::Identifier)
    assert(arg.expr.is_a? Nasl::String)
    assert_equal(arg.expr, call.arg['b'])

    arg = call.args[2]
    assert_equal(:named, arg.type)
    assert(arg.name.is_a? Nasl::Identifier)
    assert(arg.expr.is_a? Nasl::Lvalue)
    assert_equal(arg.expr, call.arg['c'])
  end

  def test_mixed_args
    tree = parse("foo(a:1, '2', c:three, bar());")
    assert_not_nil(tree)

    calls = tree.all(:Call)
    assert_not_nil(calls)
    assert_equal(2, calls.length)

    call = calls[1]
    assert_not_nil(call)
    assert_equal(4, call.args.length)

    arg = call.args[0]
    assert_equal(:named, arg.type)
    assert(arg.name.is_a? Nasl::Identifier)
    assert(arg.expr.is_a? Nasl::Integer)
    assert_equal(arg.expr, call.arg['a'])

    arg = call.args[1]
    assert_equal(:anonymous, arg.type)
    assert(arg.expr.is_a? Nasl::String)

    arg = call.args[2]
    assert_equal(:named, arg.type)
    assert(arg.name.is_a? Nasl::Identifier)
    assert(arg.expr.is_a? Nasl::Lvalue)
    assert_equal(arg.expr, call.arg['c'])

    arg = call.args[3]
    assert_equal(:anonymous, arg.type)
    assert(arg.expr.is_a? Nasl::Call)
  end
end
