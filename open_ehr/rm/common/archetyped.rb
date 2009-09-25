# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109318114715_211173_0Report.html
# Ticket refs #65
module OpenEHR
  module RM
    module Common
      module Archetyped
        module LocaterConstants
          CURRENT_TRANSACTION_ID = "current"
          FRAGMENT_SEPARATOR = "#"
          CONTENT_PATH_SEPARATOR = "|"
          ORGANIZER_PATH_SEPARATOR = "/"
          MULTIPART_ID_DELIMITER = "::"
        end

        class Pathable
          attr_accessor :parent

          def initialize(args = { })
            self.parent = args[:parent]
          end

          def item_at_path(path)
            raise NotImplementedError, "item_at_path must be implemented"
          end

          def items_at_path(path)
            raise NotImplementedError, "items_at_path must be implemented"
          end

          def path_exists?(path)
            raise NotImplementedError, "path_exists? must be implemented"
          end

          def path_of_item(item)
            raise NotImplementedError, "path_of_item must be implemented"
          end

          def path_unique?(path)
            raise NotImplementedError, "path_unique? must be implemented"
          end
        end

        class Locatable < Pathable
          include LocaterConstants
          attr_reader :archetype_node_id, :name, :links
          attr_accessor :uid, :archetype_details, :feeder_audit

          def initialize(args = { })
            super(args)
            self.archetype_node_id = args[:archetype_node_id]
            self.name = args[:name]
            self.links = args[:links]
            self.uid = args[:uid]
            self.archetype_details = args[:archetype_details]
            self.feeder_audit = args[:feeder_audit]
          end
          
          def archetype_node_id=(archetype_node_id)
            if archetype_node_id.nil? or archetype_node_id.empty?
              raise ArgumentError, 'archetype_node_id should not be nil'
            end
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

        class FeederAudit
          attr_reader :originating_system_audit
          attr_accessor :originating_system_item_ids, :feeder_system_audit,
                        :feeder_system_item_ids, :original_content

          def initialize(args = { })
            self.originating_system_audit = args[:originating_system_audit]
            self.originating_system_item_ids = args[:originating_system_item_ids]
            self.feeder_system_audit = args[:feeder_system_audit]
            self.feeder_system_item_ids = args[:feeder_system_item_ids]
            self.original_content = args[:original_content]
          end

          def originating_system_audit=(originating_system_audit)
            if originating_system_audit.nil?
              raise ArgumentError, 'originating_system_audit must be not nil'
            end
            @originating_system_audit = originating_system_audit
          end
        end # of FeederAudit

        class FeederAuditDetails
          attr_reader :system_id
          attr_accessor :provider, :location, :time, :subject, :version_id

          def initialize(args ={ })
            self.system_id = args[:system_id]
            self.provider = args[:provider]
            self.location = args[:location]
            self.time = args[:time]
            self.subject = args[:subject]
            self.version_id = args[:version_id]
          end

          def system_id=(system_id)
            raise ArgumentError, 'system_id invalid' if system_id.nil? or system_id.empty?
            @system_id = system_id
          end
        end # of FeederAudit_Details
      end # of Archetyped
    end # of Common
  end # of RM
end # OpenEHR
