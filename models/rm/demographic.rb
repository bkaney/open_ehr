module OpenEHR
  module RM
    module Demogrphic
      # this class is based on the UML,
      # http://www.openehr.org/svn/specification/TAGS/Release-1.0.1/publishing/architecture/computable/UML/uml_start_view.html
      class PARTY < OpenEHR::RM::Common::Archetyped::Locatable
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
          return name
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
      class ACTOR < PARTY
        LEAGAL_IDENTITY = 'leagal identity'
        attr_reader :languages, :rules
        def initialize(uid, archetype_node_id, name, archetype_details,
                       feeder_audit, links, identities, contacts,
                       relationships, reverse_relationships, details,
                       languages, rules)
          super(uid, archetype_node_id, name, archetype_details,
                feeder_audit, links, relationships, reverse_relationships,
                details)
          has_legal_identity?
          set_languages(languages)
          set_rules(rules)
        end
        def has_legal_identity?
          @identities.each {|identity|
            if (identity.purpose.value == LEAGAL_IDENTITY)
              return true
            end
          }
          false
        end
        def languages=(languages)
          set_languages(languages)
        end
        def values=(values)
          set_values(values)
        end
        private
        def set_languages(languages)
          if languages.nil?
            raise ArgumentError, "languages should not be nil."
          elsif languages.empty?
            raise ArgumentError, "languages shouldnot be empty."
          end
          @languages = languages
        end
        def set_values(values)
          if values.nil?
            raise ArgumentError, "values should not be nil."
          elsif values.empty?
            raise ArgumentError, "values should not be nil."
          end
          @values = values
      end
      class CONTACT < OpenEHR::RM::Common::Archetyped::Locatable
        attr_accessor :time_validity
        attr_reader :addresses
        def initialize(uid, archetype_node_id, name, archetype_details,
                       feeder_audit, links, parent, time_validity, addresses)
          super(uid, archetype_node_id, name, archetype_details,
                feeder_audit, links, parent)
          address_exists?(addresses)
          @addresses = addresses
          @time_validity = time_validity
        end
        def purpose
          @name
        end
        def purpose=(purpose)
          @name = purpose
        end
        def addresses=(addresses)
          address_exists?(addresses)
          @addresses = addresses
        end
        private
        def address_exists?(addresses)
          if addresses.nil?
            raise ArgumentError, "address must not be nil"
          elsif addresses.empty?
            raise ArgumentError, "address must not be empty"
          end
        end
      end
    end # of Demographic
  end # of RM
end # of OpenEHR
