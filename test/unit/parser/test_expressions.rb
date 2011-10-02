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

class TestExpressions < Test::Unit::TestCase
  include Nasl::Test

  def test_parentheses
    pass("q = (-a);")
    pass("q = (~a);")
    pass("q = (a);")
    pass("q = (a + b);")
    pass("q = (a + (b + c));")
    pass("q = ((a + b) + (b + d));")
    pass("q = (a + b) == c;")
    pass("q = (a + b) == (c + d);")
    pass("q = ((a + b) == (c + d));")
    pass("q = (a + b) >> c;")
    pass("q = (a + b) >> (c + d);")
    pass("q = ((a + b) >> (c + d));")
    pass("q = (((1)));")
    pass("q = (((a = b)));")
  end

  def test_bitwise
    pass("q = 0 | 1;")
  end

  def test_precedence
    same(
      'q = a + b / c + d;',
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>+</op><expression><op>+</op><lvalue><identifier name="a"/></lvalue><expression><op>/</op><lvalue><identifier name="b"/></lvalue><lvalue><identifier name="c"/></lvalue></expression></expression><lvalue><identifier name="d"/></lvalue></expression></assignment></tree>'
    )
  end
end
