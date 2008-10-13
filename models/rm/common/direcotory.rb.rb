# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_5_1_76d0249_1140536622627_218703_7149Report.html
# Ticket refs #63
module OpenEHR
  module RM
    module Common
      module Directory
        class Folder < OpenEHR::RM::Archetyped::Locatable
          attr_reader :items
          def initialize(archetype_node_id, name, links, parent=nil, items=nil, uid = nil)
            super(archetype_node_id, name, links)
            
          end
        end
      end      
    end
  end
end
