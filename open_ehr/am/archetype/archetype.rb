require 'rm/support/terminology.rb'

module OpenEhr
  module AM
    module Archetype
      module ADL_Definition
#        include OpenEHR::RM::Support::Terminology::OpenEHR_Code_Set_Identifier
        include OpenEhr::RM::Support::Terminology
        CURRENT_ADL_VERSION = "1.4"
      end

      class ARCHETYPE < OpenEhr::RM::Common::Resource::AuthoredResource
        include ADL_Definition
        attr_accessor :archetype_id, :concept_code, :is_controlled, :original_language, :parent_archtype_id, :uid

        attr_reader :parent_id,:concept, :definition, :ontology
        attr_accessor :adl_version,:description,:original_language
        attr_accessor :revision_history, :translation

        def initialize(args = {})
          @adl_version = args[:adl_version] if args[:adl_version]
          @archetype_id = args[:archetype_id] ? args[:archetype_id] : nil
          @parent_id = args[:parent_id] if args[:parent_id]
          @concept = args[:concept] if args[:concept]
          @is_controled = args[:is_controled] if args[:is_controled]
          @definition = args[:definition] if args[:definition]
          @ontology = args[:ontology] if args[:ontology]
 #         loadMaps(definition)
          super
        end

        def self.create(args ={}, &block)
          archetype = new(args)
          if block_given?
            yield archetype
          end
          return archetype
        end

        def concept_name(a_lang)
        end

        def constraint_references_valid?
        end

        def internal_references_valid?
        end

        def is_specialised?
        end

        def is_valid?
        end

        def logical_paths(a_lang)          
        end

        def node_ids_vaild?
        end

        def physical_paths
        end

        def previous_version
        end

        def short_concept_name
        end

        def specialisation_depth
        end
        
        def version
        end
      end # end of ARCHETYPE
      # original file:
      # ref_imple_eiffel/components/adl_parser/src/interface/adl_definition.e

      class VALIDITY_KIND
      end
    end


  end # end of AM
end # end of OpenEHR
