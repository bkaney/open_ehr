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
          attr_reader :parent
          def initialize(parent)
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
      end # end of Archetyped
    end # end of Common
  end # end of RM
end # end of OpenEHR
