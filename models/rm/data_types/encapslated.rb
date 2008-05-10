module OpenEHR
  module RM
    module Data_Types
      module Encapsulated
        class DV_Encapsulated  < OpenEHR::RM::Data_Types::Basic::Data_Value
          attr_accessor :charset, :language
          def size
            raise NotImplementedError, "size method not implemented"
          end
          private
          def size_positive
            raise ArgumentError, "size must be positive" if size < 0
          end
        end
        class DV_Multimedia < DV_Encapsulated
          
        end
        class DV_Parsable < DV_Encapsulated
          attr_reader :value, :formalism
          def initialize(value, formalism, charset = nil, language = nil)
            @value = value
            size_positive
            formalism_validity(formalism)
            @formalism = formalism
            @charset, @language = charset, language
          end
          def size
            value.size
          end
          private
          def formalism_validity(formalism)
            if formalism.nil
              raise ArgumentError, "formalism must not be nil"
            elsif formalism.empty?
              raise ArgumentError, "formalism must nto be empty"
            end
          end
        end
      end # of Encapsulated
    end # of Data_Types
  end # of RM
end # of OpenEHR
