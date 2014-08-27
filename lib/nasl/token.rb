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

module Nasl
  class Token
    attr_reader :body, :ctx, :name, :region, :type

    def initialize(type, body, region, ctx)
      @type = type
      @body = body
      @region = region
      @ctx = ctx
    end

    def context(*args)
      @ctx.context(@region, *args)
    end

    def name
      case @type
      when *[:BREAK, :CONTINUE, :ELSE, :EXPORT, :FOR, :FOREACH, :FUNCTION,
            :GLOBAL, :IF, :IMPORT, :INCLUDE, :LOCAL, :REPEAT, :RETURN, :UNTIL,
            :REP, :WHILE]
        "a keyword"
      when :UNDEF
        "an undefined constant"
      when *[:FALSE, :TRUE]
        "a boolean constant"
      when :IDENT
        "an identifier"
      when *[:DATA, :STRING]
        "a string"
      when *[:INT_DEC, :INT_HEX, :INT_OCT]
        "an integer"
      when :EOF
        "the end of the file"
      else
        "an operator"
      end
    end

    def to_s
      @body
    end
  end
end
