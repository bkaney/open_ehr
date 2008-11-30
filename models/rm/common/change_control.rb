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
            unless uid.nil?
              if uid.empty?
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
        end
        class Imported_Version < Version
        end
        class Original_Version < Version
        end
      end # of Change_Control
    end # of Common
  end # of RM
end # of OpenEHR
