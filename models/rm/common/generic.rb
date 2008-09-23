# This module is a implementation of the bellow UML
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_5_1_76d0249_1140169202660_257304_813Report.html
# Related to the ticket #62
module OpenEHR
  module RM
    module Common
      module Generic
        class Audit_Details
        end
        class Revision_History
          
        end # of Revision_History

        class Revision_History_Item
          
        end # of Revision_History_Item

        class Party_Proxy
          def external_ref
            Raise NotImplementedError, 'external_ref shoud provide Party_Ref'
          end
        end

        class Party_Self < Party_Proxy

        end

        class Party_Identified < Party_Proxy

        end

      end # of Generic
    end # of Common
  end # of RM
end # of OpenEHR
