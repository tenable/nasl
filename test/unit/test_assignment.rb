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

require 'test_helper'

class TestAssignment < Test::Unit::TestCase

  def test_number
    same(
      "q = 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><integer value="0"/></assignment></tree>'
    )
  end

  def test_string
    same(
      "q = '';",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><data></data></assignment></tree>'
    )
    same(
      "q = 'foo';",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><data>foo</data></assignment></tree>'
    )
    same(
      'q = "";',
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><string></string></assignment></tree>'
    )
    same(
      'q = "foo";',
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><string>foo</string></assignment></tree>'
    )
  end

  def test_function
    same(
      "q = foo();",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><call><identifier name="foo"/></call></assignment></tree>'
    )
  end

  def test_chain
    same(
      'b = a = 0;',
      '<tree><assignment><op>=</op><lvalue><identifier name="b"/></lvalue><assignment><op>=</op><lvalue><identifier name="a"/></lvalue><integer value="0"/></assignment></assignment></tree>'
    )
    same(
      'b = 1 + a = 0;',
      '<tree><assignment><op>=</op><lvalue><identifier name="b"/></lvalue><binary_expression><op>+</op><integer value="1"/><assignment><op>=</op><lvalue><identifier name="a"/></lvalue><integer value="0"/></assignment></binary_expression></assignment></tree>'
    )
    same(
      'c = 1 + b = 1 + a = 0;',
      '<tree><assignment><op>=</op><lvalue><identifier name="c"/></lvalue><binary_expression><op>+</op><integer value="1"/><assignment><op>=</op><lvalue><identifier name="b"/></lvalue><binary_expression><op>+</op><integer value="1"/><assignment><op>=</op><lvalue><identifier name="a"/></lvalue><integer value="0"/></assignment></binary_expression></assignment></binary_expression></assignment></tree>'
    )
  end

  def test_expression
    same(
      "q = 0 + 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><binary_expression><op>+</op><integer value="0"/><integer value="0"/></binary_expression></assignment></tree>'
    )
    same(
      "q = 0 - 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><binary_expression><op>-</op><integer value="0"/><integer value="0"/></binary_expression></assignment></tree>'
    )
    same(
      "q = 0 * 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><binary_expression><op>*</op><integer value="0"/><integer value="0"/></binary_expression></assignment></tree>'
    )
    same(
      "q = 0 / 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><binary_expression><op>/</op><integer value="0"/><integer value="0"/></binary_expression></assignment></tree>'
    )
    same(
      "q = 0 % 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><binary_expression><op>%</op><integer value="0"/><integer value="0"/></binary_expression></assignment></tree>'
    )
  end

  def test_conditional
    same(
      "if (q = foo());",
      '<tree><if><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><call><identifier name="foo"/></call></assignment><empty/></if></tree>'
    )
    same(
      "while (q = foo());",
      '<tree><while><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><call><identifier name="foo"/></call></assignment><empty/></while></tree>'
    )
  end
end
