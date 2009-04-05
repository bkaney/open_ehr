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
          attr_reader :uid, :contribution, :commit_audit, :signature
          attr_reader :attestations, :data
          def initialize(uid, contribution, commit_audit, signature=nil, attestations=nil, data=nil)
            self.uid = uid
            self.contribution = contribution          
            self.commit_audit = commit_audit
          end
          def uid=(uid)
            raise ArgumentError, "uid should not be nil" if uid.nil?
          end
          def contribution=(contribution)
            raise ArgumentError, "contribution should not be nil" if contribution.nil? or contribution.type == ''
            @contribution = contribution
          end
          def commit_audit=(commit_audit)
            raise ArgumentError, "commit_audit should not be nil" if commit_audit.nil?
            @commit_audit = commit_audit
          end
        end

        class Imported_Version < Version
        end

        class Original_Version < Version
        end
      end # of Change_Control
    end # of Common
  end # of RM
end # of OpenEHR
