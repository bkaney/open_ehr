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
      end # of Assetion
    end # of Archtype
  end #of AM
end # of OpenEHR
