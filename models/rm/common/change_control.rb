# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109326589721_134411_997Report.html
# Ticket refs #64

module OpenEHR
  module RM
    module Common
      module Change_Control
        class Contribution
          attr_reader :uid, :versions, :audit

          def initialize(uid, versions, audit)
            self.uid = uid
            self.versions = versions
            self.audit = audit
          end

          def uid=(uid)
            if uid.nil?
              raise ArgumentError, "uid should not be nil."
            end
            @uid = uid
          end

          def versions=(versions)
            unless versions.nil?
              if versions.empty?
                raise ArgumentError, 'versions shoud not be nil or empty.'
              end
            end
            @versions = versions
          end

          def audit=(audit)
            if audit.nil?
              raise ArgumentError, 'audit should not be nil.'
            end
            if audit.description.nil?
              raise ArgumentError, 'audit.description should not be nil.'
            end
            @audit = audit
          end
        end

        class Versioned_Object
        end

        class Version
          attr_reader :uid, :preceding_version_uid, :lifecycle_state,
                      :commit_audit, :contribution
          attr_accessor :data, :signature

          def initialize(args = { })
            self.uid = args[:uid]
            self.preceding_version_uid = args[:preceding_version_uid]
            self.data = args[:data]
            self.lifcycle_state = args[:lifecycle_state]
            self.commit_audit = args[:commit_audit]
            self.contribution = args[:contribution]
            self.signature = args[:signature]
          end

          def uid=(uid)
            raise ArgumentError, "uid should not be nil" if uid.nil?
            @uid = uid
          end

          def preceding_version_uid=(preceding_version_uid)
            if (!preceding_version_uid.nil?) ==  @uid.version_tree_id.is_first?
              raise ArgumentError, 'preceding version is invalid'
            end
            @preceding_version_uid = preceding_version_uid
          end

          def lifcycle_state=(lifecycle_state)
            if lifecycle_state.nil? ||
                !%w[532 553 523].include?(
                              lifecycle_state.defining_code.code_string)
              raise ArgumentError, 'invalid lifecycle_state'
            end
            @lifecycle_state = lifecycle_state
          end

          def commit_audit=(commit_audit)
            if commit_audit.nil?
              raise ArgumentError,'commit_audit is mandatory'
            end
            @commit_audit = commit_audit
          end

          def contribution=(contribution)
            raise ArgumentError, "contribution should not be nil" if contribution.nil? or contribution.type.empty?
            @contribution = contribution
          end

          def owner_id
            return Hier_Object_ID.new(@uid.object_id.value)
          end

          def is_branch?
            return @uid.is_branch?
          end

          def canonical_form
            raise NotImplementedError, 'canonical form not implemented'
          end
        end

        class Imported_Version < Version
        end

        class Original_Version < Version
          attr_reader :attestations

          def initialize(args = { })
            super(args)
            self.attestations = args[:attestations]
            self.other_input_version_uids = args[:other_input_version_uids]
          end

          def attestations=(attestations)
            if attestations.nil? || attestations.empty?
              raise ArgumentError, 'attestations is mandatory'
            end
            @attestations = attestations
          end

          def other_input_version_uids=(other_input_version_uids)
            if !other_input_version_uids.nil? && other_input_version_uids.empty?
              raise ArgumentError, 'invaild other_input_version_uids'
            end
            @other_input_version_uids = other_input_version_uids
          end

          def is_merged?

          end
        end
      end # of Change_Control
    end # of Common
  end # of RM
end # of OpenEHR
