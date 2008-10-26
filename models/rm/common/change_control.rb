# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109326589721_134411_997Report.html
# Ticket refs #64

module OpenEHR
  module RM
    module Common
      module Change_Control
        class Contribution
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
