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

        class ARCHETYPE_ONTOLOGY < ArchetypeOntology

        end

        class ArchetypeTerm
          attr_accessor :items
          attr_reader :code

          def initialize(args = { })
            self.code = args[:code]
            self.items =args[:items]
          end            

          def code=(code)
            if code.nil? or code.empty?
              raise ArgumentError, 'code is mandatory'
            end
            @code = code
          end

          def keys
            if items.nil?
              return Set.new
            else
              return Set.new(@items.keys)
            end
          end
        end

        class ARCHETYPE_TERM < ArchetypeTerm

        end
      end # end of Ontology
    end # end of Archetype
  end # end of AM
end # end of OpenEHR

