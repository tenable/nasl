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

module Nasl
  class Node
    attr_reader :tokens

    def initialize(tree, *tokens)
      # Register new node in the tree.
      tree.register(self)

      # Create the attributes array which is used for converting the parse tree
      # to XML.
      @attributes = []

      # Store all of the tokens that made up this node.
      @tokens = tokens
    end

    def context(*args)
      @tokens.first.context(args.shift, region, *args)
    end

    def region
      @tokens.first.region.begin..@tokens.last.region.end
    end

    def to_xml(xml)
      # Mangle the class name into something more appropriate for XML.
      name = self.class.name.split('::').last
      name = name.gsub(/(.)([A-Z])/, '\1_\2').downcase

      # If there are no attributes, make a modified opening tag.
      return xml.tag!(name) if @attributes.empty?

      # Create the tag representing this node.
      xml.tag!(name) do
        @attributes.each do |name|
          # Retrieve the object that the symbol indicates.
          obj = self.send(name)

          # Skip over unused attributes.
          next if obj.nil?

          # Handle objects that are arrays holding nodes, or basic types that
          # aren't nodes.
          if obj.is_a? Array
            obj.each { |node| node.to_xml(xml) }
          elsif obj.is_a? Node
            obj.to_xml(xml)
          else
            xml.tag!(name, obj.to_s)
          end
        end
      end
    end
  end
end
