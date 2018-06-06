################################################################################
# Copyright (c) 2011-2018, Tenable Network Security
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
  class Function < Node
    attr_reader :body, :name, :params, :attribute, :fn_type

    def initialize(tree, *tokens)
      super

      @body = @tokens.last
      @fn_type = @tokens[1]

      if @fn_type == "obj"
        if @tokens.length == 8 
          @name = @tokens[3]
          @attribute = @tokens[0]
          @params = @tokens[5]          
        elsif @tokens.length == 7
          if @tokens[0].is_a?(Token) && @tokens[0].type == :FUNCTION
            @attribute = nil
            @params = @tokens[4]
            @name = @tokens[2]
          else
            @name = @tokens[3]
            @attribute = @tokens[0]
            @params = []
          end
	elsif @tokens.length == 6
          @attribute = nil
          @params = []
          @name = @tokens[2]
        end
      else
        @name = @tokens[2]
        @attribute = []
        if @tokens.length == 7
          @params = @tokens[4]
        else
          @params = []
        end
      end

      @children << :name
      @children << :attribute
      @children << :params
      @children << :body
      @children << :fn_type
    end

    def each
      @body.each{ |stmt| yield stmt }
    end

  end
end
