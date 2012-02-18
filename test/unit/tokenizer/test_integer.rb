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

class TestTokenizerInteger < Test::Unit::TestCase
  include Nasl::Test

  def exhaustive(base, type, prefix="")
    # Test all 16-bit integers.
    0.upto(2 ** 16 - 1) do |integer|
      tkz = tokenize("#{prefix}#{integer.to_s(base)}")
      assert_nothing_raised(Nasl::TokenException) { tkz.get_token }
      assert_equal(type, tkz.reset.get_token.first)
    end
  end

  def test_bad_hex
    "g".upto("z") do |digit|
      [:downcase, :upcase].each do |type|
        tkz = tokenize("0x#{digit}".send(type))
        assert_raise(Nasl::TokenException) { tkz.get_token }
      end
    end
  end

  def test_bad_decimal
    1.upto(9) do |digit|
      "a".upto("z") do |letter|
        tkz = tokenize("#{digit}#{letter}")
        assert_raise(Nasl::TokenException) { tkz.get_token }
      end
    end
  end

  def test_exhaustive_hex
    exhaustive(16, :INT_HEX, "0x")
  end

  def test_exhaustive_octal
    exhaustive(8, :INT_OCT, "0")
  end

  def test_exhaustive_decimal
    exhaustive(10, :INT_DEC)
  end
end
