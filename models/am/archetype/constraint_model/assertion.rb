module OpenEHR
  module AM
    module Archetype
      module Assertion
        class ASSERTION
        end

        class ASSERTION_VARIABLE
        end

        class OPERATOR_KIND
        end

        class EXPR_ITEM
        end

        class EXPR_LEAF < EXPR_ITEM
        end

        class EXPR_OPERATOR < EXPR_ITEM
        end

        class EXPR_UNARY_OPERATOR < EXPR_OPERATOR
        end

        class EXPR_BINARY_OPERATOR < EXPR_OPERATOR
        end
      end
    end
  end
end
