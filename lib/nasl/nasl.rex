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

class Nasl::Grammar

macro

  ##############################################################################
  # Literals
  ##############################################################################

  IDENT      [_a-zA-Z][_a-zA-Z0-9]*

  DEC_INT    [0-9]+
  HEX_INT    0[xX][0-9a-fA-F]+
  OCT_INT    0[1-7][0-9]*

  STRING     \"[^\"]*\"
  DATA       \'

  ##############################################################################
  # Symbols
  ##############################################################################

  ASS_EQ      =    # Assignment
  ADD_EQ      \+=  # Addition
  SUB_EQ      -=   # Subtraction
  MUL_EQ      \*=  # Multiplication
  DIV_EQ      \/=  # Division
  MOD_EQ      %=   # Modulo
  SRL_EQ      >>=  # Shift Right Logical
  SRA_EQ      >>>= # Shift Right Arithmetic (sign extension)
  SLL_EQ      <<=  # Shift Left Logical

  OR          \|\|
  AND         &&
  CMP_LT      <
  CMP_GT      >
  CMP_EQ      ==
  CMP_NE      !=
  CMP_GE      >=
  CMP_LE      <=
  SUBSTR_EQ   ><
  SUBSTR_NE   >!<
  REGEX_EQ    =~
  REGEX_NE    !~
  BIT_OR      \|
  BIT_XOR     \^
  BIT_AND     &
  BIT_SRA     >>>
  BIT_SRL     >>
  BIT_SLL     <<
  ADD         \+
  SUB         -
  DIV         \/
  MUL         \*
  MOD         %
  NOT         !
  BIT_NOT     ~
  EXP         \*\*
  INCR        \+\+
  DECR        --

  ##############################################################################
  # Whitespace
  ##############################################################################

  BLANK       \s+
  COMMENT     \#[^\n]*

rule

  {BLANK}
  {COMMENT}

  {IDENT}       { t(:IDENT,     text) }
  {HEX_INT}     { t(:HEX_INT,   text) }
  {OCT_INT}     { t(:OCT_INT,   text) }
  {DEC_INT}     { t(:DEC_INT,   text) }
  {STRING}      { t(:STRING,    text) }
  {DATA}        {
      		  while true
      		    char = ss.scan(/.|\n/)
                    break if char.nil?
                    text += char
                    break if char == "'"

      		    if char == '\\'
      		      char = ss.scan(/./)
                      break if char.nil?
                      text += char
      		    end
      		  end

                  t(:DATA,      text)
                }

  {SUBSTR_EQ}   { t(:SUBSTR_EQ, text) }
  {SUBSTR_NE}   { t(:SUBSTR_NE, text) }

  {REGEX_EQ}    { t(:REGEX_EQ,  text) }
  {REGEX_NE}    { t(:REGEX_NE,  text) }

  {CMP_EQ}      { t(:CMP_EQ,    text) }
  {CMP_NE}      { t(:CMP_NE,    text) }
  {CMP_LE}      { t(:CMP_LE,    text) }
  {CMP_GE}      { t(:CMP_GE,    text) }

  {ASS_EQ}      { t(:ASS_EQ,    text) }
  {ADD_EQ}      { t(:ADD_EQ,    text) }
  {SUB_EQ}      { t(:SUB_EQ,    text) }
  {MUL_EQ}      { t(:MUL_EQ,    text) }
  {DIV_EQ}      { t(:DIV_EQ,    text) }
  {MOD_EQ}      { t(:MOD_EQ,    text) }
  {SRL_EQ}      { t(:SRL_EQ,    text) }
  {SRA_EQ}      { t(:SRA_EQ,    text) }
  {SLL_EQ}      { t(:SLL_EQ,    text) }

  {OR}          { t(:OR,        text) }
  {AND}         { t(:AND,       text) }
  {NOT}         { t(:NOT,       text) }

  {BIT_OR}      { t(:BIT_OR,    text) }
  {BIT_XOR}     { t(:BIT_XOR,   text) }
  {BIT_AND}     { t(:BIT_AND,   text) }
  {BIT_SRA}     { t(:BIT_SRA,   text) }
  {BIT_SRL}     { t(:BIT_SRL,   text) }
  {BIT_SLL}     { t(:BIT_SLL,   text) }

  {CMP_LT}      { t(:CMP_LT,    text) }
  {CMP_GT}      { t(:CMP_GT,    text) }

  {INCR}        { t(:INCR,      text) }
  {DECR}        { t(:DECR,      text) }

  {EXP}         { t(:EXP,       text) }

  {ADD}         { t(:ADD,       text) }
  {SUB}         { t(:SUB,       text) }
  {MUL}         { t(:MUL,       text) }
  {DIV}         { t(:DIV,       text) }
  {MOD}         { t(:MOD,       text) }
  {BIT_NOT}     { t(:BIT_NOT,   text) }

  .             { t(text,       text) }

inner

  # Generates tokens.
  def t(type, text)
    keywords = {
      'break'      => :BREAK,
      'continue'   => :CONTINUE,
      'else'       => :ELSE,
      'export'     => :EXPORT,
      'for'        => :FOR,
      'foreach'    => :FOREACH,
      'function'   => :FUNCTION,
      'global_var' => :GLOBAL,
      'if'         => :IF,
      'import'     => :IMPORT,
      'include'    => :INCLUDE,
      'local_var'  => :LOCAL,
      'repeat'     => :REPEAT,
      'return'     => :RETURN,
      'until'      => :UNTIL,
      'x'          => :REP,
      'while'      => :WHILE
    }

    constants = {
      'FALSE'      => :FALSE,
      'NULL'       => :UNDEF,
      'TRUE'       => :TRUE
    }

    # Identifiers may be prefixed with keywords. One example of a valid
    # identifier is "break_". To ensure that we catch these cases, we initially
    # parse all keywords as identifiers and then convert them as needed.
    if type == :IDENT && keywords.has_key?(text)
      type = keywords[text]
    end

    # Identifiers may be prefixed with constants. One example of a valid
    # identifier is "NULL_". To ensure that we catch these cases, we initially
    # parse all constants as identifiers and then convert them as needed.
    if type == :IDENT && constants.has_key?(text)
      type = constants[text]
    end

    return [type, text]
  end

end
