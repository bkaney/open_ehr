# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109318114715_211173_0Report.html
# Ticket refs #65
module OpenEHR
  module RM
    module Common
      module Archetyped
        module Locater_Constants
          CURRENT_TRANSACTION_ID = "current"
          FRAGMENT_SEPARATOR = "#"
          CONTENT_PATH_SEPARATOR = "|"
          ORGANIZER_PATH_SEPARATOR = "/"
          MULTIPART_ID_DELIMITER = "::"
        end

        class Pathable
          attr_accessor :parent
          def initialize(parent = nil)
            @parent = parent
          end
          def item_at_path(path)
            raise NotImplementError, "item_at_path must be implemented"
          end
          def items_at_path(path)
            raise NotImplementError, "items_at_path must be implemented"
          end
          def path_exists?(path)
            raise NotImplementError, "path_exists? must be implemented"
          end
          def path_of_item(item)
            raise NotImplementError, "path_of_item must be implemented"
          end
          def path_unique(path)
            raise NotImplementError, "path_unique must be implemented"
          end
        end

        class Locatable < Pathable
          include Locater_Constants
          attr_accessor :uid, :archetype_node_id, :archetype_details
          attr_accessor :feeder_audit, :links, :parent
          def initialize(uid, archetype_node_id, name, archetype_details,
                         feeder_audit, links, parent)
            super(parent)
            if archetype_node_id.nil?
              raise ArgumentError, "null archetype_node_id"
            end
            if name.nil?
              raise ArgumentError, "name is empty"
            end
            if links.nil?
              raise ArgumentError, "links is empty"
            end
            @uid = uid
            @archetype_node_id = archetype_node_id
            @archetype_details = archetype_details
            @feeder_audit = feeder_audit
            @links = links
            @parent = parent
          end
          def item_at_path(path)
            if !@path.nil?
              if @path == ""
                raise ArgumentError, "path is not valid"
              end
            end
          end
          def items_at_path(path)
            raise NotImplementError, "items_at_path must be implemented"
          end
          def path_exists?
            raise NotImplementError, "path_exists? must be implemented"
          end
          def path_unique
            raise NotImplementError, "path_unique must be implemented"
          end
          def concept
          end
          def is_archetype_root?
            !archetype_details.nil?
          end
        end
        class Archetyped
          attr_reader :archetype_id, :rm_version
          attr_accessor :template_id
          def initialize(archetype_id, rm_version, template_id = nil)            
            self.archetype_id = archetype_id
            self.rm_version = rm_version
            @template_id = template_id
          end
          def archetype_id=(archetype_id)
            raise ArgumentError, "invalid archetype_id" if archetype_id.nil?
            @archetype_id = archetype_id
          end
          def rm_version=(rm_version)
            raise ArgumentError, "invalid rm_version" if rm_version.nil? or rm_version.empty?
            @rm_version = rm_version
          end
        end
      end # end of Archetyped
    end # end of Common
  end # end of RM
end # end of OpenEHR
