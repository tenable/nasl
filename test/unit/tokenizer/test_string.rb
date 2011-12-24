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

class TestTokenizerString < Test::Unit::TestCase
  include Nasl::Test

  def test_empty
    # Tokenize empty single-quoted string.
    tkz = tokenize(%q|''|)
    type, tok = tkz.get_token
    assert_equal(:DATA, type)
    assert_equal("", tok.body)

    # Tokenize empty double-quoted string.
    tkz = tokenize(%q|""|)
    type, tok = tkz.get_token
    assert_equal(:STRING, type)
    assert_equal("", tok.body)
  end

  def test_trailing_escapes
    # Tokenize single-quoted string with trailing escape character. This should
    # raise an exception single-quoted strings allow escape sequences, including
    # escaping single quotes.
    tkz = tokenize(%q|'\\'|)
    assert_raise(Nasl::TokenException) { tkz.get_token }

    # Tokenize double-quoted string with trailing escape character. This should
    # not raise an exception since double-quoted strings do not allow escape
    # sequences.
    tkz = tokenize(%q|"\\"|)
    assert_nothing_raised(Nasl::TokenException) { tkz.get_token }
  end

  def test_multiple_escapes
    1.upto(10) do |i|
      tkz = tokenize("'" + ("\\" * i) + "'")

      # If there are an even number of escape sequences, then each one is
      # 'stuffed' so it is a valid single-quoted string.
      fn = if i % 2 == 0 then :assert_nothing_raised else :assert_raise end
      self.send(fn, Nasl::TokenException) { tkz.get_token }
    end

    1.upto(10) do |i|
      # Any number of repeated escape sequences is fine, since they're ignored.
      tkz = tokenize('"' + ("\\" * i) + '"')
      assert_nothing_raised(Nasl::TokenException) { tkz.get_token }
    end
  end

  def test_missing_quote
    # Tokenize unterminated single-quoted string.
    tkz = tokenize(%q|'|)
    assert_raise(Nasl::TokenException) { tkz.get_token }

    # Tokenize unterminated double-quoted string.
    tkz = tokenize(%q|"|)
    assert_raise(Nasl::TokenException) { tkz.get_token }
  end

  def test_multiline
    # Tokenize multiline single-quoted string.
    tkz = tokenize(%q|'\n.\n.\n'|)
    assert_nothing_raised(Nasl::TokenException) { tkz.get_token }

    # Tokenize multiline double-quoted string.
    tkz = tokenize(%q|"\n.\n.\n"|)
    assert_nothing_raised(Nasl::TokenException) { tkz.get_token }
  end
end
