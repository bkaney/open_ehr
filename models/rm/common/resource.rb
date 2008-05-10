require 'set'
module OpenEHR
  module RM
    module Common
      module Resource
        class AUTHORED_RESOURCE
          attr_reader :is_controled,:revision_history, :translations
          attr_accessor :description, :original_language

          def initialize(args = { })
            @original_language = args[:original_language] if args[:original_language]
            @translations = args[:translations] if args[:translations]
            @revision_history = args[:revision_history] ? args[:revision_history] : nil

            unless @revision_history
              @is_controled = false
            else
              @is_controled = true
            end

            @original_language = args[:original_language] if args[:original_language]
            @translations = args[:translations] if args[:translations]
            @description = args[:description] if args[:description]
          end

          def current_version
            @revision_history.most_recent_revision
          end

          def language_available
            languages = Set.new
            if @translations != nil
              languages << @translations.keys
            end
            languages << @original_language.code_string
          end
        end

        class TRANSLATION_DETAILS
          attr_accessor :language, :author, :accreditation
          attr_accessor :other_details, :terminology_service

          def initialize(language, author, accreditation, other_details,
                         terminology_service)
            @language = language
            @author = author
            @accreditation = accreditation
            @other_details = other_details
            @terminology_service = terminology_service
          end
        end
      end
    end # end of module Common
  end # end of module RM
end # end of module OpenEHR
