###############################################################################
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

require 'rainbow'

module Nasl
  class Context
    def initialize(code, path)
      @code = code
      @path = path

      # Find all of the newlines in the source code.
      i = 0
      @newlines = @code.split(/\n/).map do |nl|
        i += 1 + nl.length
      end

      # Treat the start and end of the file as a newlines to simplify the bol
      # and eol functions.
      @newlines.unshift(0)
      @newlines.push(@code.length)

      # Storing the list of newlines in descending order makes the row and
      # column code nicer.
      @newlines.reverse!
    end

    def bol(point)
      @newlines.find { |nl| nl <= point }
    end

    def eol(point)
      @code.index(/\n/, point) || @code.length
    end

    def col(point)
      # Columns use base zero indexing.
      point - bol(point)
    end

    def row(point)
      # Rows use base one indexing.
      @newlines.length - @newlines.index { |nl| nl <= point }
    end

    def context(inner, outer=nil, header=true, color=true)
      # If no outer region was provided, we will assume that the desired outer
      # is from the beginning of the line that the inner region starts on to the
      # end of the line that the inner region finishes on.
      outer = bol(inner.begin)..eol(inner.end) if outer.nil?

      # If the outer region argument was provided, but wasn't a Range, access
      # its region member.
      outer = outer.region unless outer.is_a? Range

      ctx = ""
      point = inner.begin

      # Create the location header.
      ctx << "Context for row #{row(point)}, column #{col(point)} in file #@path:\n" if header

      # Create the text to the left of the region. The only case where there is
      # no text to the left is at the start of the program.
      if outer.begin != inner.begin
        line = @code[outer.begin..inner.begin - 1]
        line = line.color(:green) if color
        ctx << line
      end

      # Create the text in the region.
      line = @code[inner.begin..inner.end - 1]
      line = line.color(:red) if color
      ctx << line

      # Create the text to the right of the region.
      line = @code[inner.end..outer.end].chomp
      line = line.color(:green) if color
      ctx << line

      ctx << "\n"
    end
  end
end
