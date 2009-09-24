module OpenEhr
  module RM
    module Content
      module Entry
        class Entry < Content_Item
        end
        class CareEntry < Entry
        end
        class Action < CareEntry
          attr_accessor :description, :time
          attr_accessor :ism_transition, :instruction_details
          def initialize(description, time, ism_transition, instruction_details)
            raise Exception.new("invalid argument") if description == nil || time == nil || ism_transition == nil
            @description = description
            @time = time
            @ism_transition = ism_transition
            @instruction_details = instruction_details if instruction_details != nil
          end
        end # end of Action
      end # end of Entry
    end # end of Content
  end # end of RM
end # end of OpenEHR
