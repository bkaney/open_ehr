# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_5_1_76d0249_1140536622627_218703_7149Report.html
# Ticket refs #63
module OpenEHR
  module RM
    module Common
      module Directory
        class Folder < OpenEHR::RM::Common::Archetyped::Locatable
          attr_accessor :items
          attr_reader :folders

          def initialize(archetype_node_id, name, links, parent=nil, folders=nil, items=nil, uid = nil, archetype_details=nil, feeder_audit=nil)
            super(archetype_node_id, name, links, parent, uid, archetype_details, feeder_audit)
            self.folders = folders
          end

          def folders=(folders)
            raise ArgumentError, "empty subfolder" if !folders.nil? and folders.empty?
            @folders = folders
          end
        end        
      end # of Directory
    end # of Common
  end # of RM
end # of OpenEHR
