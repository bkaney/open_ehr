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
          attr_reader :language, :charset, :size
          def initialize(charset, language, size)
            self.charset = charset
            self.language = language
            self.size = size
          end

          def size=(size)
            if size < 0
              raise ArgumentError, "negative size"
            end
            @size = size
          end

          def language=(language)
            if language.nil? ||
                !Locale::Info.language_code?(language.code_string)
              raise ArgumentError, 'invalid language code'
            end
            @language = language
          end

          def charset=(charset)
            if charset.nil? || !charset_valid?(charset.code_string)
              raise ArgumentError, 'invalid charset'
            end
            @charset = charset
          end

          private
          def size_positive
            raise ArgumentError, "size must be positive" if size < 0
          end

          def charset_valid?(charset)
            result = false
            open('rm/data_types/charset.lst') do |file|
              while line = file.gets
                if charset == line.chomp
                  result = true
                  break
                end
              end
            end
            return result
          end
        end

# media type http://www.iana.org/assignments/media-types/text/
        class DV_Multimedia < DV_Encapsulated
          def initialize(charset, language, size, media_type, uri=nil,
                         data=nil, compression_algorithm=nil,
                         integrity_check=nil, integrity_check_algorithm=nil,
                         alternate_text=nil)

          end
          
        end

        class DV_Parsable < DV_Encapsulated
          attr_reader :value, :formalism
          def initialize(charset, language, size, formalism, value)
            super(charset, language, size)
            self.formalism = formalism
            self.value = value
          end

          def value=(value)
            raise ArgumentError, 'value must not be nil' if value.nil?
            @value = value
          end

          def formalism=(formalism)
            if formalism.nil?
              raise ArgumentError, "formalism must not be nil"
            elsif formalism.empty?
              raise ArgumentError, "formalism must nto be empty"
            end
            @formalism = formalism
          end
        end
      end # of Encapsulated
    end # of Data_Types
  end # of RM
end # of OpenEHR
