module OpenEHR
  module AM
    module Archetype
      module Ontology
        class ArchetypeOntology
          attr_accessor :constraint_codes, :specialisation_depth
          attr_accessor :term_attribute_names, :term_codes
          attr_accessor :terminologies_available

          def constraint_binding(a_terminology, a_code)
          end

          def constraint_definition(a_lang, a_code)
          end

          def has_language?(a_lang)
          end

          def has_terminology?(a_terminology)
          end

          def term_binding(a_terminology, a_code)
          end

          def term_definition(a_lang, a_code)
          end
        end

        class ARCHETYPE_TERM
          attr_accessor :code, :items

          def initialize(args = { })
                         
            @code = if args[:code]
                      args[:code]
                    else
                      raise ArgumentError, "Code is empty"
                    end
            @items = if args[:items]
                       args[:items]
                     else
                       raise ArgumentError, "Items is empty"
                     end
          end

          def keys
            @items.keys
          end
        end
      end # end of Ontology
    end # end of Archetype
  end # end of AM
end # end of OpenEHR

