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

class TestArray < Test::Unit::TestCase
  include Nasl::Test

  def test_empty
    tree = parse("foo = {};")
    assert_not_nil(tree)

    arrays = tree.all(:Array)
    assert_not_nil(arrays)
    assert_equal(1, arrays.length)

    array = arrays.first
    assert_not_nil(array)
    assert_equal(0, array.pairs.length)
  end

  def test_integers
    tree = parse("foo = {1:02, 3:4, 5:0x6};")
    assert_not_nil(tree)

    arrays = tree.all(:Array)
    assert_not_nil(arrays)
    assert_equal(1, arrays.length)

    array = arrays.first
    assert_not_nil(array)
    assert_equal(3, array.pairs.length)

    assert_equal(1, array.pairs[0].key.value)
    assert_equal(array.keys[1], array.pairs[0].value)
    pair = array.pairs[0]
    assert(pair.key.is_a? Nasl::Integer)
    assert(pair.value.is_a? Nasl::Integer)
    assert_equal(2, pair.value.value)

    assert_equal(3, array.pairs[1].key.value)
    assert_equal(array.keys[3], array.pairs[1].value)
    pair = array.pairs[1]
    assert(pair.key.is_a? Nasl::Integer)
    assert(pair.value.is_a? Nasl::Integer)
    assert_equal(4, pair.value.value)

    assert_equal(5, array.pairs[2].key.value)
    assert_equal(array.keys[5], array.pairs[2].value)
    pair = array.pairs[2]
    assert(pair.key.is_a? Nasl::Integer)
    assert(pair.value.is_a? Nasl::Integer)
    assert_equal(6, pair.value.value)
  end

  def test_string
    tree = parse(%q|foo = {'a':"b", "c":'d'};|)
    assert_not_nil(tree)

    arrays = tree.all(:Array)
    assert_not_nil(arrays)
    assert_equal(1, arrays.length)

    array = arrays.first
    assert_not_nil(array)
    assert_equal(2, array.pairs.length)

    pair = array.pairs[0]
    assert(pair.key.is_a? Nasl::String)
    assert_equal(:DATA, pair.key.type)
    assert_equal('a', pair.key.text)
    assert(pair.value.is_a? Nasl::String)
    assert_equal(:STRING, pair.value.type)
    assert_equal('b', pair.value.text)
    assert_equal(pair.value, array.keys['a'])

    pair = array.pairs[1]
    assert(pair.key.is_a? Nasl::String)
    assert_equal(:STRING, pair.key.type)
    assert_equal('c', pair.key.text)
    assert(pair.value.is_a? Nasl::String)
    assert_equal(:DATA, pair.value.type)
    assert_equal('d', pair.value.text)
    assert_equal(pair.value, array.keys['c'])
  end

  def test_mixed
    tree = parse(%q|foo = {'a':1, 2:"b"};|)
    assert_not_nil(tree)

    arrays = tree.all(:Array)
    assert_not_nil(arrays)
    assert_equal(1, arrays.length)

    array = arrays.first
    assert_not_nil(array)
    assert_equal(2, array.pairs.length)

    pair = array.pairs[0]
    assert(pair.key.is_a? Nasl::String)
    assert_equal(:DATA, pair.key.type)
    assert_equal('a', pair.key.text)
    assert(pair.value.is_a? Nasl::Integer)
    assert_equal(1, pair.value.value)
    assert_equal(pair.value, array.keys['a'])

    pair = array.pairs[1]
    assert(pair.key.is_a? Nasl::Integer)
    assert_equal(2, pair.key.value)
    assert(pair.value.is_a? Nasl::String)
    assert_equal(:STRING, pair.value.type)
    assert_equal('b', pair.value.text)
    assert_equal(pair.value, array.keys[2])
  end

  # A single trailing comma in an array literal is valid, but multiple is not.
  def test_single_trailing_comma
    tree = parse(%q|foo = {'a':1, 2:"b",};|)
    assert_not_nil(tree)

    arrays = tree.all(:Array)
    assert_not_nil(arrays)
    assert_equal(1, arrays.length)

    array = arrays.first
    assert_not_nil(array)
    assert_equal(2, array.pairs.length)

    pair = array.pairs[0]
    assert(pair.key.is_a? Nasl::String)
    assert_equal(:DATA, pair.key.type)
    assert_equal('a', pair.key.text)
    assert(pair.value.is_a? Nasl::Integer)
    assert_equal(1, pair.value.value)
    assert_equal(pair.value, array.keys['a'])

    pair = array.pairs[1]
    assert(pair.key.is_a? Nasl::Integer)
    assert_equal(2, pair.key.value)
    assert(pair.value.is_a? Nasl::String)
    assert_equal(:STRING, pair.value.type)
    assert_equal('b', pair.value.text)
    assert_equal(pair.value, array.keys[2])
  end

  def test_multiple_trailing_comma
    fail_parse(%q|foo = {'a':1, 2:"b",,};|)
  end

  def test_empty_array_with_comma
    fail_parse(%q|return {,};|)
  end
end
