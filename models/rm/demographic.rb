module OpenEHR
  module RM
    module Demogrphic
      class Party < OpenEHR::RM::Common::Archetyped::Locatable
        attr_reader :details, :reverse_relationships, :uid
        attr_reader :idetities, :contacts, :relationships
        def initialize(uid, archetype_node_id, name, archetype_details,
                       feeder_audit, links, identities, contacts,
                       relationships, reverse_relationships, details)
          super(uid, archetype_node_id, name, archetype_details,
                feeder_audit, links, nil)
          uid_valid(uid)
          @uid = uid
          identities_vaild(identities)
          @identities = identities
          contacts_valid(contacts)
          @contacts = contacts
          relationships_valid(relationships)
        end
        def type
          
        end
        def uid=(uid)
          uid_valid(uid)
          @uid = uid
        end
        def identities=(identities)
          identities_vaild(identities)
          @identities = identities
        def contacts=(contacts)
          contacts_valid(contacts)
          @contacts = contacts
        end
        def parent=(parent)
          @parent = nil
        end
        private
        def uid_valid(uid)
          raise ArgumentError, "uid is not valid" if uid.nil?
        end
        def identities_vaild(identities)
          if identities.nil?
            raise ArgumentError, "identities must not be nil"
          elsif identities.empty?
            raise ArgumentError, "identities must not be empty"
          end
        end
        def contacts_valid(contacts)
          if contacs.nil?
            raise ArgumentError, "contacts must not be nil"
          elsif contacts.empty?
            raise ArgumentError, "contacts must not be empty"
          end          
        end
      end
      class Actor < Party
        
      end
    end # of Demographic
  end # of RM
end # of OpenEHR
