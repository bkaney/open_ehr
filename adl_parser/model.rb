require 'logger'


module OpenEHR
  module ADL
    module Model
      module Archetype
        class ARCHETYPE
          attr_accessor :adl_version, :archetype_id, :uid, :concept, :parent_archetype_id, :definition, :ontology, :invariants

          def version
          end
          
          def previous_version
          end

          def short_concept_name
          end

          def concept_name
          end
          
          def physical_path
          end

          def logiacl_path
          end

          def is_specialized
          end

          def specilisation_depth
          end

          def node_ids_valid
          end

          def internal_references_valid
          end

          def constraint_references_valid
          end

          def is_valid
          end
        end

        
        class ConstraintModel

          class ArchetypeConstraint
            def is_valid
            end

            def has_path
            end

            def path
            end

            def is_subset_of
            end
          end

          class CObject
          end

          class CAttribute
          end

          class CSingleAttribute < CAttribute
          end

          class CMultipleAttribute < CAttribute
          end

          class CDefinedObject
          end

          class CComplexObject < CDefinedObject
          end


          class CPrimitiveObject < CDefinedObject
          end

          class CDomainType < CDefinedObject
          end

          class CReferenceObject < CObject
          end
        end

        class Assertion
        end

        class Ontology
        end
      end
    end
  end
end
