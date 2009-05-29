# OpenEHR::RM::Data_Types::Encapsulated 
# http://www.openehr.org/svn/specification/TAGS/Release-1.0.2/publishing/architecture/computable/UML/uml_start_view.html
# refs #51
require 'rubygems'
require 'locale/info'

module OpenEHR
  module RM
    module Data_Types
      module Encapsulated
        class DV_Encapsulated  < OpenEHR::RM::Data_Types::Basic::Data_Value
          attr_reader :language, :charset

          def size
            raise NotImplementedError, "size method not implemented"
          end

          def language=(language)
            unless Language::Info.valid_language?(language.code_string)
              raise ArgumentError, 'invalid language code'
            end
            @language = language
          end

          def charset=(charset)
            unless charset_valid?(charset)
              raise ArgumentError, 'invalid charset'
            end
            @charset=charset
          end

          private
          def size_positive
            raise ArgumentError, "size must be positive" if size < 0
          end

          def charset_valid?(charset)
            open('charset.list') do |file|
              while line = file.gets
                if charset == line
                  file.close
                  return true
                end
              end
            end
            return false
          end
        end

        class DV_Multimedia < DV_Encapsulated
          
        end

        class DV_Parsable < DV_Encapsulated
          attr_reader :value, :formalism
          def initialize(value, formalism, charset = nil, language = nil)
            @value = value
            size_positive
            formalism_validity(formalism)
            @formalism = formalism
            @charset, @language = charset, language
          end
          def size
            value.size
          end
          private
          def formalism_validity(formalism)
            if formalism.nil
              raise ArgumentError, "formalism must not be nil"
            elsif formalism.empty?
              raise ArgumentError, "formalism must nto be empty"
            end
          end
        end
      end # of Encapsulated
    end # of Data_Types
  end # of RM
end # of OpenEHR
