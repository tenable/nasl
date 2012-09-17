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

class TestTokenizerComment < Test::Unit::TestCase
  include Nasl::Test

  def verify(code, expected)
    tkz = tokenize(code)
    received = tkz.get_tokens

    expected << [:EOF, "$"]

    0.upto(received.length - 1) do |i|
      tok = received[i].last

      # Handle more tokens than expected.
      if expected[i].nil?
        assert_equal([nil, nil], [tok.type, tok.body])
        break
      end

      assert_equal(expected[i].first, tok.type, tok.context)
      assert_equal(expected[i].last, tok.body, tok.context)
    end

    # Handle less tokens than expected.
    if received.length < expected.length
      assert_equal(expected[received.length], [nil, nil])
    end

    assert_equal(expected.length, received.length)
  end

  def test_empty
    # Tokenize empty comment.
    0.upto(3).each do |i|
      pad = ' ' * i
      verify(pad + '#', [[:COMMENT, '#']])
    end
  end

  def test_whitespace
    # Tokenize whitespace comment.
    0.upto(3).each do |i|
      pad = ' ' * i
      verify('#' + pad, [[:COMMENT, '#' + pad]])
    end
  end

  def test_block
    code = <<-EOF
      # Line 1
      # Line 2
      # Line 3
    EOF

    verify(code, [[:COMMENT, "# Line 1\n# Line 2\n# Line 3"]])
  end

  def test_unaligned
    code = <<-EOF
      # Comment 1
       # Comment 2
    EOF

    verify(code, [[:COMMENT, "# Comment 1"]])
  end

  def test_disjoint
    code = <<-EOF
      # Comment 1

      # Comment 2
    EOF

    verify(code, [[:COMMENT, "# Comment 1"]])
  end

  def test_hidden_before
    code = <<-EOF
      foo = TRUE;
      # Comment
      foo = TRUE;
    EOF

    assign = [
      [:IDENT, "foo"],
      [:ASS_EQ, "="],
      [:TRUE, "TRUE"],
      [:SEMICOLON, ";"],
    ]

    verify(code, assign + assign) 
  end

  def test_hidden_aften
    code = <<-EOF
      foo = TRUE;

      # Comment
    EOF

    verify(
      code,
      [
        [:IDENT, "foo"],
        [:ASS_EQ, "="],
        [:TRUE, "TRUE"],
        [:SEMICOLON, ";"],
      ]
    )
  end

  def test_export
    code = <<-EOF
      foo = TRUE;

      # Export
      export function bar() {}
    EOF

    verify(
      code,
      [
        [:IDENT, "foo"],
        [:ASS_EQ, "="],
        [:TRUE, "TRUE"],
        [:SEMICOLON, ";"],

        [:COMMENT, "# Export"],

        [:EXPORT, "export"],
        [:FUNCTION, "function"],
        [:IDENT, "bar"],
        [:LPAREN, "("],
        [:RPAREN, ")"],
        [:LBRACE, "{"],
        [:RBRACE, "}"]
      ]
    )
  end

  def test_function
    code = <<-EOF
      foo = TRUE;

      # Function
      function bar() {}
    EOF

    verify(
      code,
      [
        [:IDENT, "foo"],
        [:ASS_EQ, "="],
        [:TRUE, "TRUE"],
        [:SEMICOLON, ";"],

        [:COMMENT, "# Function"],

        [:FUNCTION, "function"],
        [:IDENT, "bar"],
        [:LPAREN, "("],
        [:RPAREN, ")"],
        [:LBRACE, "{"],
        [:RBRACE, "}"]
      ]
    )
  end

  def test_global
    code = <<-EOF
      foo = TRUE;

      # Global
      global_var bar;
    EOF

    verify(
      code,
      [
        [:IDENT, "foo"],
        [:ASS_EQ, "="],
        [:TRUE, "TRUE"],
        [:SEMICOLON, ";"],

        [:COMMENT, "# Global"],

        [:GLOBAL, "global_var"],
        [:IDENT, "bar"],
        [:SEMICOLON, ";"]
      ]
    )
  end
end
