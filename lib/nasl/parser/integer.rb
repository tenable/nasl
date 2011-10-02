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

require 'nasl/parser/node'

module Nasl
  class Integer < Node
    attr_reader :base, :value

    def initialize(tree, *tokens)
      super

      @base = case @tokens.first.type
              when :INT_DEC
                10
              when :INT_HEX
                16
              when :INT_OCT
                8
              when :FALSE
                10
              when :TRUE
                10
              end

      @value = case @tokens.first.type
               when :FALSE
                 0
               when :TRUE
                 1
               else
                 @tokens.first.body.to_i(@base)
               end
    end

    def to_xml(xml)
      case @tokens.first.type
      when :FALSE
        xml.false
      when :TRUE
        xml.true
      else
        xml.integer(:value=>@value)
      end
    end
  end
end
