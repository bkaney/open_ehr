module OpenEHR
  module AM
    module Archetype
      module Assertion
        class Assertion
          attr_reader :expression, :tag
          attr_accessor :string_expression, :variables

          def initialize(args = { })
            self.expression = args[:expression]
            self.tag = args[:tag]
            self.string_expression = args[:string_expression]
            self.variables = args[:variables]
          end

          def expression=(expression)
            if expression.nil? or expression.type.upcase != 'BOOLEAN'
              raise ArgumentError, 'invalid expression'
            end
            @expression = expression
          end

          def tag=(tag)
            if !tag.nil? && tag.empty?
              raise ArgumentError, 'tag should not be empty'
            end
            @tag = tag
          end
        end

        class ExprItem
          attr_reader :type

          def initialize(args = { })
            self.type = args[:type]
          end

          def type=(type)
            if type.nil? or type.empty?
              raise ArgumentError, 'type is mandatory'
            end
            @type = type
          end
        end

        class ExprLeaf < ExprItem
          attr_reader :item, :reference_type

          def initialize(args = { })
            super
            self.item = args[:item]
            self.reference_type = args[:reference_type]
          end

          def item=(item)
            if item.nil?
              raise ArgumentError, 'item is mandatory'
            end
            @item = item
          end

          def reference_type=(reference_type)
            if reference_type.nil?
              raise ArgumentError, 'reference_type is mandatory'
            end
            @reference_type = reference_type
          end
        end

        class ExprOperator < ExprItem
          attr_accessor :operator, :precedence_overridden

          def initialize(args = { })
            super
            self.operator = args[:operator]
            self.precedence_overridden = args[:precedence_overridden]
          end
        end

        class OperatorKind
          OP_EQ = 2001
          OP_NE = 2002
          OP_LE = 2003
          OP_LT = 2004
          OP_GE = 2005
          OP_GT = 2006
          OP_MATCHES = 2007

          OP_NOT = 2010
          OP_AND = 2011
          OP_OR = 2012
          OP_XOR = 2013
          OP_IMPLIES = 2014
          OP_FOR_ALL = 2015
          OP_EXISTS = 2016

          OP_PLUS = 2020
          OP_MINUS = 2021
          OP_MULTIPLY = 2022
          OP_DIVIDE = 2023
          OP_EXP = 2024

          attr_reader :value

          def initialize(args = { })
            self.value = args[:value]
          end

          def value=(value)
            unless OperatorKind.valid_operator? value
              raise ArgumentError, 'invalid value'
            end
            @value = value
          end

          def self.valid_operator?(value)
            if value >= OP_EQ && value <= OP_EXP
              return true
            else
              return false
            end
          end
        end
      end # of Assetion
    end # of Archtype
  end #of AM
end # of OpenEHR
