################################################################################
# Copyright (c) 2011-2014, Tenable Network Security
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

class TestAssignment < Test::Unit::TestCase
  include Nasl::Test

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
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><call><lvalue><identifier name="foo"/></lvalue></call></assignment></tree>'
    )
  end

  def test_reference
    same(
      "q = @foo;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><reference><identifier name="foo"/></reference></assignment></tree>'
    )
  end

  def test_chain
    same(
      'b = a = 0;',
      '<tree><assignment><op>=</op><lvalue><identifier name="b"/></lvalue><assignment><op>=</op><lvalue><identifier name="a"/></lvalue><integer value="0"/></assignment></assignment></tree>'
    )
    same(
      'b = 1 + a = 0;',
      '<tree><assignment><op>=</op><lvalue><identifier name="b"/></lvalue><expression><op>+</op><integer value="1"/><assignment><op>=</op><lvalue><identifier name="a"/></lvalue><integer value="0"/></assignment></expression></assignment></tree>'
    )
    same(
      'c = 1 + b = 1 + a = 0;',
      '<tree><assignment><op>=</op><lvalue><identifier name="c"/></lvalue><expression><op>+</op><integer value="1"/><assignment><op>=</op><lvalue><identifier name="b"/></lvalue><expression><op>+</op><integer value="1"/><assignment><op>=</op><lvalue><identifier name="a"/></lvalue><integer value="0"/></assignment></expression></assignment></expression></assignment></tree>'
    )
  end

  def test_expression
    same(
      "q = 0 + 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>+</op><integer value="0"/><integer value="0"/></expression></assignment></tree>'
    )
    same(
      "q = 0 - 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>-</op><integer value="0"/><integer value="0"/></expression></assignment></tree>'
    )
    same(
      "q = 0 * 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>*</op><integer value="0"/><integer value="0"/></expression></assignment></tree>'
    )
    same(
      "q = 0 / 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>/</op><integer value="0"/><integer value="0"/></expression></assignment></tree>'
    )
    same(
      "q = 0 % 0;",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>%</op><integer value="0"/><integer value="0"/></expression></assignment></tree>'
    )
  end

  def test_conditional
    same(
      "if (q = foo());",
      '<tree><if><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><call><lvalue><identifier name="foo"/></lvalue></call></assignment><empty/></if></tree>'
    )
    same(
      "while (q = foo());",
      '<tree><while><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><call><lvalue><identifier name="foo"/></lvalue></call></assignment><empty/></while></tree>'
    )
  end

  def test_list
    same(
      "q = [];",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><list></list></assignment></tree>'
    )

    same(
      "q = [[[]], [[]], [[]]];",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><list><list><list></list></list><list><list></list></list><list><list></list></list></list></assignment></tree>'
    )

    same(
      "q = [1];",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><list><integer value="1"/></list></assignment></tree>'
    )

    same(
      "q = [1, 'b', foo()];",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><list><integer value="1"/><data>b</data><call><lvalue><identifier name="foo"/></lvalue></call></list></assignment></tree>'
    )

    same(
      "foo(arg:[1]);",
      '<tree><call><lvalue><identifier name="foo"/></lvalue><argument type="named"><identifier name="arg"/><list><integer value="1"/></list></argument></call></tree>'
    )

    same(
      "q = [] + [];",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>+</op><list></list><list></list></expression></assignment></tree>'
    )
  end

  def test_array
    same(
      "q = {};",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><array></array></assignment></tree>'
    )

    same(
      "q = {'a':{'b':{}}, 'c':{'d':{}}, 'e':{'f':{}}};",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><array><key_value_pair><data>a</data><array><key_value_pair><data>b</data><array></array></key_value_pair></array></key_value_pair><key_value_pair><data>c</data><array><key_value_pair><data>d</data><array></array></key_value_pair></array></key_value_pair><key_value_pair><data>e</data><array><key_value_pair><data>f</data><array></array></key_value_pair></array></key_value_pair></array></assignment></tree>'
    )

    same(
      'q = {"a":1};',
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><array><key_value_pair><string>a</string><integer value="1"/></key_value_pair></array></assignment></tree>'
    )

    same(
      "q = {1:1, 2:'b', 3:foo()};",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><array><key_value_pair><integer value="1"/><integer value="1"/></key_value_pair><key_value_pair><integer value="2"/><data>b</data></key_value_pair><key_value_pair><integer value="3"/><call><lvalue><identifier name="foo"/></lvalue></call></key_value_pair></array></assignment></tree>'
    )

    same(
      "foo(arg:{1:1});",
      '<tree><call><lvalue><identifier name="foo"/></lvalue><argument type="named"><identifier name="arg"/><array><key_value_pair><integer value="1"/><integer value="1"/></key_value_pair></array></argument></call></tree>'
    )

    same(
      "q = {} + {};",
      '<tree><assignment><op>=</op><lvalue><identifier name="q"/></lvalue><expression><op>+</op><array></array><array></array></expression></assignment></tree>'
    )
  end
end
