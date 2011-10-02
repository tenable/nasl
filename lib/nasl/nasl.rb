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

require 'builder'

module Nasl
  autoload :Parser, 'pedant/parser'

  ############################################################################
  # Base Classes
  ############################################################################
  class Tree < Array
    def all(cls)
      (@all[Nasl.const_get(cls).to_s] ||= [])
    end

    def register(node)
      (@all[node.class.name] ||= []) << node
    end

    def initialize
      @all = {}
    end

    def to_s
      text = ''

      xml = Builder::XmlMarkup.new(:target=>text, :indent=>2)

      if !empty?
        xml.tree { self.map { |node| node.to_xml(xml) } }
      else
        xml.tree
      end

      text
    end
  end

  class Node
    def self.all
      (Node.nodes[self.to_s] ||= [])
    end

    def self.nodes
      (@_nodes ||= {})
    end

    def initialize(tree, *args)
      # Register new node globally, in this module.
      Node.nodes[self.class.name] ||= []
      Node.nodes[self.class.name] << self

      # Register new node locally, in the tree.
      tree.register(self)

      # Create the attributes array which is used for converting the parse
      # tree to XML.
      @attributes = []
    end

    def to_xml(xml)
      # Mangle the class name into something more appropriate for XML.
      name = self.class.name.split('::').last
      name = name.gsub(/(.)([A-Z])/, '\1_\2').downcase

      # Create the tag representing this node.
      if !@attributes.empty?
        xml.tag!(name) do
          @attributes.each do |name|
            # Retrieve the object that the symbol indicates.
            obj = self.send(name)

            # Skip over unused attributes.
            next if obj.nil?

            # Handle objects that are arrays holding nodes, or basic types
            # that aren't nodes.
            if obj.is_a? Array
              obj.each { |node| node.to_xml(xml) }
            elsif obj.is_a? Node
              obj.to_xml(xml)
            else
              xml.tag!(name, obj.to_s)
            end
          end
        end
      else
        xml.tag!(name)
      end
    end
  end

  ############################################################################
  # Root Statements
  ############################################################################

  class Export < Node
    attr_reader :function

    def initialize(tree, function)
      super

      @function = function

      @attributes << :function
    end
  end

  class Function < Node
    attr_reader :body, :name, :params

    def initialize(tree, name, params, body)
      super

      @name = name
      @params = params
      @body = body

      @attributes << :name
      @attributes << :params
      @attributes << :body
    end
  end

  ############################################################################
  # Simple Statements
  ############################################################################

  class Assignment < Node
    attr_reader :expr, :lval, :op

    def initialize(tree, lval, op, expr)
      super

      @op = op
      @lval = lval
      @expr = expr

      @attributes << :op
      @attributes << :lval
      @attributes << :expr
    end
  end

  class Break < Node
  end

  class Call < Node
    attr_reader :arg, :args, :name

    def initialize(tree, name, args)
      super

      @name = name
      @args = args

      @arg = {}
      @args.select{|a| a.type == :named}.each do |a|
        @arg[a.name.name] = a.expr
      end

      @attributes << :name
      @attributes << :args
    end
  end

  class Continue < Node
  end

  class Decrement < Node
    attr_reader :ident, :type

    def initialize(tree, ident, type)
      super

      @ident = ident
      @type = type

      @attributes << :ident
      @attributes << :type
    end
  end

  class Empty < Node
  end

  class Global < Node
    attr_reader :idents

    def initialize(tree, idents)
      super

      @idents = idents

      @attributes << :idents
    end
  end

  class Import < Node
    attr_reader :filename

    def initialize(tree, filename)
      super

      @filename = filename

      @attributes << :filename
    end
  end

  class Include < Node
    attr_reader :filename

    def initialize(tree, filename)
      super

      @filename = filename

      @attributes << :filename
    end
  end

  class Increment < Node
    attr_reader :ident, :type

    def initialize(tree, ident, type)
      super

      @ident = ident
      @type = type

      @attributes << :ident
      @attributes << :type
    end
  end

  class Local < Node
    attr_reader :idents

    def initialize(tree, idents)
      super

      @idents = idents

      @attributes << :idents
    end
  end

  class Repetition < Node
    attr_reader :call, :expr

    def initialize(tree, call, expr)
      super

      @call = call
      @expr = expr

      @attributes << :call
      @attributes << :expr
    end
  end

  class Return < Node
    attr_reader :expr

    def initialize(tree, expr)
      super

      @expr = expr

      @attributes << :expr
    end
  end

  ############################################################################
  # Compound Statements
  ############################################################################

  class Block < Node
    attr_reader :body

    def initialize(tree, body)
      super

      @body = body

      @attributes << :body
    end
  end

  class For < Node
    attr_reader :body, :cond, :each, :init

    def initialize(tree, init, cond, each, body)
      super

      @init = init
      @cond = cond
      @each = each
      @body = body

      @attributes << :init
      @attributes << :cond
      @attributes << :each
      @attributes << :body
    end
  end

  class Foreach < Node
    attr_reader :body, :expr, :iter

    def initialize(tree, iter, expr, body)
      super

      @iter = iter
      @expr = expr
      @body = body

      @attributes << :iter
      @attributes << :expr
      @attributes << :body
    end
  end

  class If < Node
    attr_reader :cond, :false, :true

    def initialize(tree, cond, t, f)
      super

      @cond = cond
      @true = t
      @false = f

      @attributes << :cond
      @attributes << :true
      @attributes << :false
    end
  end

  class Repeat < Node
    attr_reader :body, :cond

    def initialize(tree, cond, body)
      super

      @cond = cond
      @body = body

      @attributes << :cond
      @attributes << :body
    end
  end

  class While < Node
    attr_reader :body, :cond

    def initialize(tree, cond, body)
      super

      @cond = cond
      @body = body

      @attributes << :cond
      @attributes << :body
    end
  end

  ############################################################################
  # Expressions
  ############################################################################

  class Expression < Node
    attr_reader :lhs, :op, :rhs
  end

  class UnaryExpression < Expression
    def initialize(tree, op, rhs)
      super

      @op = op
      @lhs = nil
      @rhs = rhs

      @attributes << :op
      @attributes << :rhs
    end
  end

  class BinaryExpression < Expression
    def initialize(tree, lhs, op, rhs)
      super

      @lhs = lhs
      @op = op
      @rhs = rhs

      @attributes << :op
      @attributes << :lhs
      @attributes << :rhs
    end
  end

  ############################################################################
  # Named Components
  ############################################################################

  class Argument < Node
    attr_reader :expr, :name, :type

    def initialize(tree, name, expr, type)
      super

      @name = name
      @expr = expr
      @type = type

      @attributes << :name
      @attributes << :expr
    end
  end

  class Lvalue < Node
    attr_reader :ident, :indexes

    def initialize(tree, ident, indexes)
      super

      @ident = ident
      @indexes = indexes

      @attributes << :ident
      @attributes << :indexes
    end
  end

  ############################################################################
  # Literals
  ############################################################################

  class Identifier < Node
    attr_reader :name

    def initialize(tree, name)
      super

      @name = name
    end

    def to_xml(xml)
      xml.identifier(:name=>@name)
    end
  end

  class Integer < Node
    attr_reader :base, :value

    def initialize(tree, value, base)
      super

      @value = value.to_i(base)
      @base = base
    end

    def to_xml(xml)
      xml.integer(:value=>@value)
    end
  end

  class Ip < Node
    attr_reader :octets

    def initialize(tree, *octets)
      super

      @octets = octets
    end

    def to_xml(xml)
      xml.ip(:octets=>@octets.join('.'))
    end
  end

  class String < Node
    attr_reader :text, :type

    def initialize(tree, text, type)
      super

      @text = text
      @type = type
    end

    def to_xml(xml)
      if @type == :pure
        xml.data(@text)
      else
        xml.string(@text)
      end
    end
  end

  class Undefined < Node
    def to_xml(xml)
      xml.null
    end
  end
end
