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
          attr_reader :archetype_node_id, :name, :links
          attr_accessor :uid, :archetype_details, :feeder_audit

          def initialize(archetype_node_id, name, links, parent=nil, uid=nil, archetype_details=nil, feeder_audit=nil)
            super(parent)
            self.archetype_node_id = archetype_node_id
            self.name = name
            self.links = links
            self.uid = uid
            self.archetype_details = archetype_details
            self.feeder_audit = feeder_audit
            self.parent = parent
          end
          
          def archetype_node_id=(archetype_node_id)
            raise ArgumentError, 'archetype_node_id should not be nil' if archetype_node_id.nil?
            @archetype_node_id = archetype_node_id
          end

          def name=(name)
            raise ArgumentError, 'name should not be empty' if name.nil? or name.value.empty?
            @name = name
          end
          def links=(links)
            raise ArgumentError, "links shoud not be empty" if !links.nil? and links.empty?
            @links = links
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
            self.template_id = template_id
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

        class Link
          attr_reader :meaning, :target, :type
          def initialize(meaning, target, type)
            self.meaning = meaning
            self.target = target
            self.type = type
          end
          def meaning=(meaning)
            raise ArgumentError, "meaning should not be nil" if meaning.nil?
            @meaning = meaning
          end
          def target=(target)
            raise ArgumentError, "target should not be nil" if target.nil?
            @target = target
          end
          def type=(type)
            raise ArgumentError, "type should not be nil" if type.nil?
            @type = type
          end
        end # of Link

        class Feeder_Audit
          
        end # of Feeder_Audit

        class Feeder_Audit_Details
          attr_reader :system_id

          def initialize(args ={ })
            self.system_id = args[:system_id]
          end

          def system_id=(system_id)
            raise ArgumentError, 'system_id invalid' if system_id.nil? or system_id.empty?
            @system_id = system_id
          end
        end # of Feeder_Audit_Details
      end # of Archetyped
    end # of Common
  end # of RM
end # OpenEHR
