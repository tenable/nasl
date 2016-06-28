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


class TestTokenizerIdent < Test::Unit::TestCase
  include Nasl::Test

  def test_ident
    tkz = tokenize("foo")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)

    tkz = tokenize("_foo")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)

    tkz = tokenize("foo1")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)

    tkz = tokenize("foo_bar")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)
  end

  def test_ident_namespace
    tkz = tokenize("foo::var")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)

    tkz = tokenize("foo::bar::var")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)

    tkz = tokenize("::var")
    type, tok = tkz.get_token
    assert_equal(:IDENT, type)
  end

  def test_invalid_ident
    tkz = tokenize("1foo")
    assert_raise(Nasl::TokenException) { tkz.get_token }
  end

  def test_invalid_ident_namespace
    tkz = tokenize("foo::")
    assert_raise(Nasl::TokenException) { tkz.get_token }

    tkz = tokenize("foo::1var")
    assert_raise(Nasl::TokenException) { tkz.get_token }

    tkz = tokenize("::")
    assert_raise(Nasl::TokenException) { tkz.get_token }
  end
end
