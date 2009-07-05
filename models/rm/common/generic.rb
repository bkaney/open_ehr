# This module is a implementation of the bellow UML
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_5_1_76d0249_1140169202660_257304_813Report.html
# Related to the ticket #62
include OpenEHR::RM::Support::Identification
include OpenEHR::RM::Data_Types::Basic
module OpenEHR
  module RM
    module Common
      module Generic
        class Audit_Details
          attr_reader :system_id, :committer, :time_committed, :change_type
          attr_accessor :description

          def initialize(args = { })
            self.system_id = args[:system_id]
            self.committer = args[:committer]
            self.time_committed = args[:time_committed]
            self.change_type = args[:change_type]
            self.description = args[:description]
          end

          def system_id=(system_id)
            if system_id.nil? or system_id.empty?
              raise ArgumentError, 'system_id is mandatory'
            end
            @system_id = system_id
          end

          def committer=(committer)
            raise ArgumentError, 'committer is mandatory' if committer.nil?
            @committer = committer
          end

          def time_committed=(time_committed)
            if time_committed.nil?
              raise ArgumentError, 'time_commited is mandatory'
            end
            @time_committed = time_committed
          end

          def change_type=(change_type)
            raise ArgumentError, 'change_type is mandatory' if change_type.nil?
            @change_type = change_type
          end
        end

        class Revision_History
          attr_reader :items

          def initialize(items)
            self.items = items
          end

          def items=(items)
            if items.nil? or items.empty?
              raise ArgumentError, 'item(s) is/are mandatory'
            end
            @items  = items
          end

          def most_recent_version
            return @items.last.version_id.value
          end

          def most_recent_version_time_committed
            return @items.last.audits.first.time_committed.value
          end
        end # of Revision_History

        class Revision_History_Item
          attr_reader :version_id, :audits

          def initialize(args = { })
            self.version_id = args[:version_id]
            self.audits = args[:audits]
          end

          def audits=(audits)
            if audits.nil? or audits.empty?
              raise ArgumentError, 'audits is mandatory'
            end
            @audits = audits
          end

          def version_id=(version_id)
            raise ArgumentError, 'version_id is mandatory' if version_id.nil?
            @version_id = version_id
          end
        end # of Revision_History_Item

        class Party_Proxy
          attr_accessor :external_ref

          def initialize(args = { })
            self.external_ref = args[:external_ref]
          end
        end

        class Party_Self < Party_Proxy

        end

        class Party_Identified < Party_Proxy
          attr_reader :name, :identifier
          def initialize(args = { })
            if args[:external_ref].nil? && args[:name].nil? &&
                args[:identifier].nil?
              raise ArgumentError, 'cannot identified'
            end
            super(:external_ref => args[:external_ref])
            self.name = args[:name]
            self.identifier = args[:identifier]
          end

          def name=(name)
            if name.nil? && @external_ref.nil? && @identifier.nil?
              raise ArgumentError, 'cannot identified'
            end
            raise ArgumentError, 'invaild name' unless name.nil? || !name.empty?
            @name = name
          end

          def identifier=(identifier)
            if @name.nil? && @external_ref.nil? && identifier.nil?
              raise ArgumentError, 'cannot identified'
            end
            unless identifier.nil? || !identifier.empty?
              raise ArgumentError, 'invaild identifier'
            end
            @identifier = identifier
          end
        end

        class Party_Related < Party_Identified
          attr_reader :relationship
          def initialize(args = { })
            super(args)
            self.relationship = args[:relationship]
          end

          def relationship=(relationship)
            if relationship.nil?
              raise ArgumentError, 'relationship must not be nil'
            end
            @relationship = relationship
          end
        end

        class Participation
          attr_reader :performer, :function, :mode
          attr_accessor :time

          def initialize(args ={ })
            self.performer = args[:performer]
            self.function = args[:function]
            self.mode = args[:mode]
            self.time = args[:time]
          end

          def performer=(performer)
            raise ArgumentError, 'performer is mandatory' if performer.nil?
            @performer = performer
          end

          def function=(function)
            raise ArgumentError, 'function is mandatory' if function.nil?
            @function = function
          end

          def mode=(mode)
            raise ArgumentError, 'mode is mandatory' if mode.nil?
            @mode = mode
          end
        end

        class Attestation < Audit_Details
          attr_reader :reason
          attr_accessor :proof, :items

          def initialize(args = { })
            super(args)
            self.reason = args[:reason]
            self.proof = args[:proof]
            self.items = args[:items]
          end

          def reason=(reason)
            raise ArgumentError, 'reason is mandatory' if reason.nil?
            @reason = reason
          end
        end
      end # of Generic
    end # of Common
  end # of RM
end # of OpenEHR
