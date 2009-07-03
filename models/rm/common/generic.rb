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
        end
        class Revision_History
          
        end # of Revision_History

        class Revision_History_Item
          
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
      end # of Generic
    end # of Common
  end # of RM
end # of OpenEHR
