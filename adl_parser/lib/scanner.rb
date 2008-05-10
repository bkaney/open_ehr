require 'logger'
require 'rubygems'
gem 'yaparc'
require 'yaparc'


module OpenEHR
  module ADL
    module Scanner
      module Common
        LOG = Logger.new('log/scanner.log','daily')

        class V_QUALIFIED_TERM_CODE_REF
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A\[[a-zA-Z0-9()\._-]+::[a-zA-Z0-9\._-]+\]/)) do |match|
                LOG.info("V_QUALIFIED_TERM_CODE_REF: #{match}")
                [:V_QUALIFIED_TERM_CODE_REF, match]
              end
            end
          end
        end
        
        class V_LOCAL_TERM_CODE_REF
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A\[[a-zA-Z0-9][a-zA-Z0-9._\-]*\]/)) do |match|
                LOG.info("V_TERM_CODE_REF: #{match}")
                [:V_LOCAL_TERM_CODE_REF, match]
              end
            end
          end
        end

        class ERR_V_QUALIFIED_TERM_CODE_REF
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A\[[a-zA-Z0-9._\- ]+::[a-zA-Z0-9._\- ]+\]/)) do |match|
                LOG.info("ERR_V_QUALIFIED_TERM_CODE_REF: #{match}")
                [:ERR_V_QUALIFIED_TERM_CODE_REF, match]
              end
            end
          end
        end

        class V_TYPE_IDENTIFIER
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[A-Z][a-zA-Z0-9_]*/)) do |match|
                LOG.info("V_TYPE_IDENTIFIER: #{match}")
                [:V_TYPE_IDENTIFIER, match]
              end
            end
          end
        end

        class V_GENERIC_TYPE_IDENTIFIER
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[A-Z][a-zA-Z0-9_]*<[a-zA-Z0-9,_<>]+>/)) do |match|
                LOG.info("V_GENERIC_TYPE_IDENTIFIER: #{match}")
                [:V_GENERIC_TYPE_IDENTIFIER, match]
              end
            end
          end
        end


        class V_LOCAL_CODE
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\Aa[ct][0-9.]+/)) do |match|
                LOG.info("V_LOCAL_CODE: #{match}")
                [:V_LOCAL_CODE, match]
              end
            end
          end
        end

        class V_STRING
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A"([^"]*)"/m)) do |match|
                LOG.info("V_STRING: #{match}")
                [:V_STRING, match]
              end
            end
          end
        end

        class V_REAL
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[0-9]+\.[0-9]+|[0-9]+\.[0-9]+[eE][+-]?[0-9]+/)) do |match|
                LOG.info("V_REAL: #{match}")
                [:V_REAL, match]
              end
            end
          end
        end

        #V_ISO8601_DURATION PnYnMnWnDTnnHnnMnnS
        class V_ISO8601_DURATION
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(
                                Yaparc::Alt.new(Yaparc::Regex.new(/\AP([0-9]+|[yY])?([0-9]+|[mM])?([0-9]+|[wW])?([0-9]+|[dD])?T([0-9]+|[hH])?([0-9]+|[mM])?([0-9]+|[sS])?/),
                                                Yaparc::Regex.new(/\AP([0-9]+|[yY])?([0-9]+|[mM])?([0-9]+|[wW])?([0-9]+|[dD])?/))) do |match|
                LOG.info("V_ISO8601_DURATION: #{match}")
                [:V_ISO8601_DURATION, match]
              end
            end
          end
        end

      end # of Common

      module DADL
        # c.f. http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/components/adl_parser/src/syntax/adl/parser/adl_scanner.l
        RESERVED = {
          'true' => :SYM_TRUE, #[Tt][Rr][Uu][Ee] -- -> SYM_TRUE 
          'false' => :SYM_FALSE, # [Ff][Aa][Ll][Ss][Ee] -- -> SYM_FALSE 
          'infinity' => :SYM_INFINITY # [Ii][Nn][Ff][Ii][Nn][Ii][Tt][Yy] -- -> SYM_INFINITY 
        }

        class RootScanner
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Alt.new(Reserved.new,
                              OpenEHR::ADL::Scanner::Common::V_QUALIFIED_TERM_CODE_REF.new,
                              OpenEHR::ADL::Scanner::Common::V_LOCAL_TERM_CODE_REF.new,
                              OpenEHR::ADL::Scanner::Common::ERR_V_QUALIFIED_TERM_CODE_REF.new,
                              OpenEHR::ADL::Scanner::Common::V_TYPE_IDENTIFIER.new,
                              OpenEHR::ADL::Scanner::Common::V_GENERIC_TYPE_IDENTIFIER.new,
                              OpenEHR::ADL::Scanner::Common::V_STRING.new,
                              OpenEHR::ADL::Scanner::Common::V_LOCAL_CODE.new,
                              OpenEHR::ADL::Scanner::Common::V_REAL.new,
                              OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION.new
                              )
            end
          end
        end
=begin <DADL::Reserved class>
=end
        class Reserved
          include Yaparc::Parsable
          
          def initialize
            @parser = lambda do |input|
              reserved_parsers = OpenEHR::ADL::Scanner::DADL::RESERVED.map do |keyword| 
                Yaparc::Tokenize.new(
                                     Yaparc::Literal.new(keyword[0],false)
                                     )
              end
              Yaparc::Alt.new(Yaparc::Apply.new(Yaparc::Alt.new(*reserved_parsers)) do |match|
                                OpenEHR::ADL::Scanner::Common::LOG.info("Reserved: #{match}")
                                [OpenEHR::ADL::Scanner::DADL::RESERVED[match], OpenEHR::ADL::Scanner::DADL::RESERVED[match]]
                              end,
                              Yaparc::Apply.new(Yaparc::Regex.new(/\A[a-z][a-zA-Z0-9_]*/)) do |match|
                                OpenEHR::ADL::Scanner::Common::LOG.info("V_ATTRIBUTE_IDENTIFIER: #{match}")
                                [:V_ATTRIBUTE_IDENTIFIER, match]
                              end)
            end
          end
        end



      end # of DADL

      module CADL
        # c.f. http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/components/adl_parser/src/syntax/cadl/parser/cadl_scanner.l
        RESERVED = {
          'ordered' => :SYM_ORDERED, # [Oo][Rr][Dd][Ee][Rr][Ee][Dd]
          'unordered' => :SYM_UNORDERED, # [Uu][Nn][Oo][Rr][Dd][Ee][Rr][Ee][Dd]
          'then' => :SYM_THEN, # [Tt][Hh][Ee][Nn]
          'else' => :SYM_ELSE, # [Ee][Ll][Ss][Ee]
          'and' => :SYM_AND, # [Aa][Nn][Dd]
          'or' => :SYM_OR, # [Oo][Rr]
          'xor' => :SYM_XOR, # [Xx][Oo][Rr]
          'not' => :SYM_NOT, # [Nn][Oo][Tt]
          'implies' => :SYM_IMPLIES, # [Ii][Mm][Pp][Ll][Ii][Ee][Ss]
          'true' => :SYM_TRUE, #[Tt][Rr][Uu][Ee] -- -> SYM_TRUE 
          'false' => :SYM_FALSE, # [Ff][Aa][Ll][Ss][Ee] -- -> SYM_FALSE 
          'forall' => :SYM_FORALL, # [Ff][Oo][Rr][_][Aa][Ll][Ll]
          'exists' => :SYM_EXISTS, # [Ee][Xx][Ii][Ss][Tt][Ss]
          'existence' => :SYM_EXISTENCE, # [Ee][Xx][Iu][Ss][Tt][Ee][Nn][Cc][Ee]
          'occurrences' => :SYM_OCCURRENCES, # [Oo][Cc][Cc][Uu][Rr][Rr][Ee][Nn][Cc][Ee][Ss]
          'cardinality' => :SYM_CARDINALITY, # [Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
          'unique' => :SYM_UNIQUE, # [Uu][Nn][Ii][Qq][Uu][Ee]
          'matches' => :SYM_MATCHES, # [Mm][Aa][Tt][Cc][Hh][Ee][Ss]
          'is_in' => :SYM_MATCHES, # [Ii][Ss][_][Ii][Nn]
          'invariant' => :SYM_INVARIANT, # [Ii][Nn][Vv][Aa][Rr][Ii][Aa][Nn][Tt]
          'infinity' => :SYM_INFINITY, # [Ii][Nn][Ff][Ii][Nn][Ii][Tt][Yy] -- -> SYM_INFINITY 
          'use_node' => :SYM_USE_NODE, # [Uu][Ss][Ee][_][Nn][Oo][Dd][Ee]
          'use_archetype' => :SYM_ALLOW_ARCHETYPE, # [Uu][Ss][Ee][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee]
          'allow_archetype' => :SYM_ALLOW_ARCHETYPE, # [Aa][Ll][Ll][Oo][Ww][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee]
          'include' => :SYM_INCLUDE, # [Ii][Nn][Cc][Ll][Uu][Dd][Ee]
          'exclude' => :SYM_EXCLUDE # [Ee][Xx][Cc][Ll][Uu][Dd][Ee]
        }

        #V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN, /\A[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X][T\t][hH?X][hH?X]:[mM?X][mM?X]:[sS?X][sS?X]/
        class V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X][T\t][hH?X][hH?X]:[mM?X][mM?X]:[sS?X][sS?X]/)) do |match|
                OpenEHR::ADL::Scanner::Common::LOG.info("V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN: #{match}")
                [:V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN, match]
              end
            end
          end
        end

        #V_ISO8601_DATE_CONSTRAINT_PATTERN  /\A[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X]/
        class V_ISO8601_DATE_CONSTRAINT_PATTERN
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X]/)) do |match|
                OpenEHR::ADL::Scanner::Common::LOG.info("V_ISO8601_DATE_CONSTRAINT_PATTERN: #{match}")
                [:V_ISO8601_DATE_CONSTRAINT_PATTERN, match]
              end
            end
          end
        end

        #V_ISO8601_TIME_CONSTRAINT_PATTERN /\A[hH][hH]:[mM?X][mM?X]:[sS?X][sS?X]/
        class V_ISO8601_TIME_CONSTRAINT_PATTERN
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[hH][hH]:[mM?X][mM?X]:[sS?X][sS?X]/)) do |match|
                OpenEHR::ADL::Scanner::Common::LOG.info("V_ISO8601_TIME_CONSTRAINT_PATTERN: #{match}")
                [:V_ISO8601_TIME_CONSTRAINT_PATTERN, match]
              end
            end
          end
        end

        #V_ISO8601_DURATION_CONSTRAINT_PATTERN 
        class V_ISO8601_DURATION_CONSTRAINT_PATTERN
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Alt.new(Yaparc::Regex.new(/\AP[yY]?[mM]?[wW]?[dD]?T[hH]?[mM]?[sS]?/),
                                                Yaparc::Regex.new(/\AP[yY]?[mM]?[wW]?[dD]?/))) do |match|
                OpenEHR::ADL::Scanner::Common::LOG.info("V_ISO8601_DURATION_CONSTRAINT_PATTERN: #{match}")
                [:V_ISO8601_DURATION_CONSTRAINT_PATTERN, match]
              end
            end
          end
        end

        #V_C_DOMAIN_TYPE /\A[A-Z][a-zA-Z0-9_]*[ \n]*\</
        class V_C_DOMAIN_TYPE
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A[A-Z][a-zA-Z0-9_]*[ \n]*\</)) do |match|
                OpenEHR::ADL::Scanner::Common::LOG.info("V_C_DOMAIN_TYPE: #{match}")
                [:START_V_C_DOMAIN_TYPE_BLOCK, match]
              end
            end
          end
        end

        class RootScanner
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Alt.new(V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN.new,
                              V_ISO8601_DATE_CONSTRAINT_PATTERN.new,
                              V_ISO8601_TIME_CONSTRAINT_PATTERN.new,
                              OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION.new,
                              V_C_DOMAIN_TYPE.new,
                              V_ISO8601_DURATION_CONSTRAINT_PATTERN.new,
                              Reserved.new,
                              OpenEHR::ADL::Scanner::Common::V_QUALIFIED_TERM_CODE_REF.new,
                              OpenEHR::ADL::Scanner::Common::V_LOCAL_TERM_CODE_REF.new,
                              OpenEHR::ADL::Scanner::Common::ERR_V_QUALIFIED_TERM_CODE_REF.new,
                              OpenEHR::ADL::Scanner::Common::V_TYPE_IDENTIFIER.new,
                              OpenEHR::ADL::Scanner::Common::V_GENERIC_TYPE_IDENTIFIER.new,
                              OpenEHR::ADL::Scanner::Common::V_STRING.new,
                              OpenEHR::ADL::Scanner::Common::V_LOCAL_CODE.new,
                              OpenEHR::ADL::Scanner::Common::V_REAL.new,
                              OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION.new
                              )
            end
          end
        end

=begin <CADL::Reserved class>
=end
        class Reserved
          include Yaparc::Parsable
          
          def initialize
            @parser = lambda do |input|
              orderd_reserved = RESERVED.keys.sort{|x,y| y.length <=> x.length  }
              reserved_parsers = orderd_reserved.map do |keyword| 
                Yaparc::Literal.new(keyword,false)
              end
              Yaparc::Alt.new(Yaparc::Apply.new(Yaparc::Alt.new(*reserved_parsers)) do |match|
                                OpenEHR::ADL::Scanner::Common::LOG.info("Reserved: #{match}")
                                [OpenEHR::ADL::Scanner::CADL::RESERVED[match], OpenEHR::ADL::Scanner::CADL::RESERVED[match]]
                              end,
                              Yaparc::Apply.new(Yaparc::Regex.new(/\A[a-z][a-zA-Z0-9_]*/)) do |match|
                                OpenEHR::ADL::Scanner::Common::LOG.info("V_ATTRIBUTE_IDENTIFIER: #{match}")
                                [:V_ATTRIBUTE_IDENTIFIER, match]
                              end)
            end
          end
        end

      end
    end
  end
end
