# This module implemented from this UML
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109067605961_209522_3179Report.html
# Ticket refs #48
module OpenEHR
  module RM
    module Data_Types
      module Text
        class Term_Mapping
          attr_reader :match, :purpose, :target
          def initialize(match, purpose, target)
            match_valid(match)
            purpose_valid(purpose)
            target_valid(target)
            @match, @purpose, @target = match, purpose, target
          end
          def broader?
            match == '>'
          end
          def equivalent?
            match == '='
          end
          def narrower?
            match == '<'
          end
          def unknown?
            match == '?'
          end
          def Term_Mapping.is_valid_mach_code?(c)
            c == '>' or c == '=' or c == '<' or c == '?'
          end
          private
          def match_valid(match)
            raise ArgumentError, "match is not valid" if !Term_Mapping.is_valid_mach_code? match
          end
          def purpose_valid(purpose)
            if purpose.nil? or !purpose.instance_of? DV_Coded_Text
              raise ArgumentError, "purpose is not valid"
            end
            # should be settled after terminology service implemented
          end
          def target_valid(target)
            raise ArgumentError, "target must not be nil" if target.nil?
          end
        end

        class Code_Phrase
          attr_reader :terminology_id, :code_string
          def initialize(code_string, terminology_id)
            self.code_string = code_string
            self.terminology_id = terminology_id
          end

          def terminology_id=(terminology_id)
            raise ArgumentError, "terminology_id should not be nil" if terminology_id.nil?
            @terminology_id = terminology_id
          end

          def code_string=(code_string)
            raise ArgumentError, "code_string should not be empty" if code_string.nil? or code_string.empty?
            @code_string = code_string
          end 
        end # of Code_Phrase

        class DV_Text < OpenEHR::RM::Data_Types::Basic::Data_Value
          attr_reader :value, :formatting, :hyperlink, :mappings
          attr_reader :language, :encoding
          def initialize(value, formatting = nil, hyperlink = nil,
                         mappings = nil, language = nil, encoding = nil)
            value_valid(value)
            DV_Text.formatting_valid(formatting)
            DV_Text.encoding_valid(encoding)
            DV_Text.mapping_valid(mappings)
            DV_Text.language_valid(language)
            @value, @formatting, @encoding = value, formatting, encoding
            @mappings, @language = mappings, language
          end
          def value=(value)
            value_valid(value)
            @value = value
          end
          def formatting=(formatting)
            DV_Text.formatting_valid(formatting)
            @formatting = formatting
          end
          def encoding=(encoding)
            DV_Text.encoding_valid(encoding)
            @encoding = encoding
          end
          def mappings=(mappings)
            DV_Text.mapping_valid(mappings)
            @mappings = mappings
          end
          def language=(language)
            DV_Text.language_valid(language)
            @language = language
          end
          private
          def value_valid(value)
            if value.nil? or value.empty? or value.include? CR or value.include? LF
              raise ArgumentError, "value is not valid"
              # CR and LF are defined in Basic_Definition inherited Data_Value.
            end
          end

          class << self

            def formatting_valid(formatting)
              raise ArgumentError, "formatting is not valid" if formatting != nil and formatting.empty?
            end

            def encoding_valid(encoding)
              raise ArgumentError, "encoding is not valid" if encoding != nil and encoding.empty?
            end

            def mapping_valid(mapping)
              if !mapping.nil? and !mapping.instance_of? Set
                raise ArgumentError, "mapping(s) is(are) not valid"
              elsif !mapping.nil? and mapping.instance_of? Set
                raise ArgumentError, "mapping(s) is(are) not valid" if mapping.empty? 
              end
            end

            def language_valid(language)
              raise ArgumentError, "langage is not valid" if language != nil and language.empty?
            end
          end

        end

        class DV_Coded_Text < DV_Text
          attr_reader :defining_code
          def initialize(value, defining_code, formatting = nil, 
                         hyperlink = nil, mappings = nil, language = nil, 
                         encoding = nil)
            super(value, formatting, hyperlink, mappings, language, encoding)
            definition_exists(defining_code)
            @defining_code = defining_code
          end
          def defining_code=(defining_code)
            definition_exists(defining_code)
            @defining_code = defining_code
          end
          private
          def definition_exists(defining_code)
            raise ArgumentError, "Defiinition must be exist" if defining_code.nil?
          end
        end

        class DV_Paragraph < OpenEHR::RM::Data_Types::Basic::Data_Value
          attr_reader :items
          def initialize(items)
            items_exists(items)
            @items = items
          end
          def items=(items)
            items_exists(items)
            @items = items
          end
          private
          def items_exists(items)
            if !items.nil? and !items.instance_of? Set
              raise ArgumentError, "Items are not valid"
            elsif !items.nil? and items.instance_of? Set
              raise ArgumentError, "Items must be exist" if items.empty?
            end
          end
        end

      end # of Text
    end # of Data_Type
  end # of RM
end # of OpenEHR
