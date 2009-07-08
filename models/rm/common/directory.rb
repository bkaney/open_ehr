# This module is based on the UML,
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_5_1_76d0249_1140536622627_218703_7149Report.html
# Ticket refs #63
include OpenEHR::RM::Data_Types::Text
module OpenEHR
  module RM
    module Common
      module Directory
        class Folder < OpenEHR::RM::Common::Archetyped::Locatable
          attr_accessor :items
          attr_reader :folders

          def initialize(args = { })
            super(args)
            self.folders = args[:folders]
            self.items = args[:items]
          end

          def folders=(folders)
            raise ArgumentError, "empty subfolder" if !folders.nil? and folders.empty?
            @folders = folders
          end
        end        
        class Versioned_Folder < OpenEHR::RM::Common::Change_Control::Versioned_Object
        end
      end # of Directory
    end # of Common
  end # of RM
end # of OpenEHR
