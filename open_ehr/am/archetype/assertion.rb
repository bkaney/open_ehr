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
      end # of Assetion
    end # of Archtype
  end #of AM
end # of OpenEHR
