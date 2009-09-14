require 'rubygems'
require 'yaparc'
require 'logger'
require 'adl_parser.rb'
require 'am.rb'
require 'rm.rb'


module OpenEHR
  module ADL
    module Scanner

      class Base
        def initialize(adl_type, filename, lineno = 1)
          @adl_type = adl_type
          @filename = filename
          @lineno = lineno
        end

        def scan(data)
          raise
        end
      end

      class CADLScanner < Base

        @@logger = Logger.new('log/scanner.log')
        RESERVED = {
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
          'ordered' => :SYM_ORDERED, # [Oo][Rr][Dd][Ee][Rr][Ee][Dd]
          'unordered' => :SYM_UNORDERED, # [Uu][Nn][Oo][Rr][Dd][Ee][Rr][Ee][Dd]
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

        def initialize(adl_type, filename, lineno = 1)
          super(adl_type, filename, lineno)
          @in_interval = false
          @cadl_root_scanner = OpenEHR::ADL::Scanner::CADL::RootScanner.new

          @adl_scanner = lambda{OpenEHR::ADL::Scanner::ADLScanner.new(adl_type, filename)}
          @dadl_scanner = lambda{OpenEHR::ADL::Scanner::DADLScanner.new(adl_type, filename)}
          @regex_scanner = lambda{OpenEHR::ADL::Scanner::RegexScanner.new(adl_type, filename)}
          @term_constraint_scanner = lambda{OpenEHR::ADL::Scanner::TermConstraintScanner.new(adl_type, filename)}
        end

        def scan(data)
          @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_cadl at #{@filename}:#{@lineno}: data = #{data.inspect}")
          until data.nil?  do
            case @adl_type.last
            when :adl
              data = @adl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :dadl
              data = @dadl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :regexp
              data = @regex_scanner.call..scan(data) do |sym, val|
                yield sym, val
              end
            when :term_constraint
              @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")
              
              data = term_constraint_scanner.scan(data) do |sym, val|
                yield sym, val
              end
            when :cadl
#               case scanned = @cadl_root_scanner.parse(data)
#               when Yaparc::Result::OK
#                 if scanned.value[0] == :START_V_C_DOMAIN_TYPE_BLOCK
#                   @in_c_domain_type = true
#                   @adl_type.push(:dadl)
#                   yield scanned.value
#                 else
#                   yield scanned.value
#                 end
#                 data = scanned.input
#               end

              case data
              when /\A\n/ # carriage return
                @lineno += 1
                ;
              when /\A[ \t\r\f]+/ #just drop it
                ;
              when /\A--.*\n/ # single line comment
                @lineno += 1
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: COMMENT = #{$&} at #{@filename}:#{@lineno}")
                ;
                ###----------/* symbols */ ------------------------------------------------- 
              when /\A\=/   # =
                yield :SYM_EQ, :SYM_EQ
              when /\A\>=/   # >=
                yield :SYM_GE, :SYM_GE
              when /\A\<=/   # <=
                yield :SYM_LE, :SYM_LE
              when /\A\</   # <
                if @in_interval
                  yield :SYM_LT, :SYM_LT
                else
                  @adl_type.push(:dadl)
                  yield :SYM_START_DBLOCK,  $&
                end
              when /\A\>/   # >
                if @in_interval
                  yield :SYM_GT, :SYM_GT
                else
                  adl_type = @adl_type.pop
                  assert_at(__FILE__,__LINE__){adl_type == :dadl}
                  yield :SYM_END_DBLOCK, :SYM_END_DBLOCK
                end
              when /\A\-/   # -
                yield :Minus_code, :Minus_code
              when /\A\+/   # +
                yield :Plus_code, :Plus_code
              when /\A\*/   # *
                yield :Star_code, :Star_code
              when /\A\//   # /
                yield :Slash_code, :Slash_code
              when /\A\^/   # ^
                yield :Caret_code, :Caret_code
              when /\A\.\.\./   # ...
                yield :SYM_LIST_CONTINUE, :SYM_LIST_CONTINUE
              when /\A\.\./   # ..
                yield :SYM_ELLIPSIS, :SYM_ELLIPSIS
              when /\A\./   # .
                yield :Dot_code, :Dot_code
              when /\A\;/   # ;
                yield :Semicolon_code, :Semicolon_code
              when /\A\,/   # ,
                yield :Comma_code, :Comma_code
              when /\A\:/   # :
                yield :Colon_code, :Colon_code
              when /\A\!/   # !
                yield :Exclamation_code, :Exclamation_code
              when /\A\(/   # (
                yield :Left_parenthesis_code, :Left_parenthesis_code
              when /\A\)/   # )
                yield :Right_parenthesis_code, :Right_parenthesis_code
              when /\A\{\// #V_REGEXP
                if @adl_type.last != :regexp
                  @in_regexp = true
                  @adl_type.push(:regexp)
                  yield :START_REGEXP_BLOCK, :START_REGEXP_BLOCK
                else
                  raise
                end
                #        yield :V_REGEXP, :V_REGEXP
              when /\A\{/   # {
                @adl_type.push(:cadl)
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: entering cADL at #{@filename}:#{@lineno}")
                yield :SYM_START_CBLOCK, :SYM_START_CBLOCK
              when /\A\}/   # }
                adl_type = @adl_type.pop
                #        puts "Escaping #{adl_type}"
                assert_at(__FILE__,__LINE__){adl_type == :cadl}
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: exiting cADL at #{@filename}:#{@lineno}")
                yield :SYM_END_CBLOCK, :SYM_END_CBLOCK
              when /\A\$/   # $
                yield :Dollar_code, :Dollar_code
              when /\A\?\?/   # ??
                yield :SYM_DT_UNKNOWN, :SYM_DT_UNKNOWN
              when /\A\?/   # ?
                yield :Question_mark_code, :Question_mark_code
              when /\A\|/   # |
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: @in_interval = #{@in_interval} at #{@filename}:#{@lineno}")
                if @in_interval
                  @in_interval = false
                else
                  #          @in_interval = false
                  @in_interval = true
                end
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: SYM_INTERVAL_DELIM at #{@filename}:#{@lineno}")
                yield :SYM_INTERVAL_DELIM, :SYM_INTERVAL_DELIM

              when /\A\[[a-zA-Z0-9()\._-]+::[a-zA-Z0-9\._-]+\]/  #V_QUALIFIED_TERM_CODE_REF form [ICD10AM(1998)::F23]
                #      when /\A\[[a-zA-Z0-9._\-]+::[a-zA-Z0-9._\-]+\]/   #V_QUALIFIED_TERM_CODE_REF form [ICD10AM(1998)::F23]
                yield :V_QUALIFIED_TERM_CODE_REF, $&
              when /\A\[[a-zA-Z0-9._\- ]+::[a-zA-Z0-9._\- ]+\]/   #ERR_V_QUALIFIED_TERM_CODE_REF
                yield :ERR_V_QUALIFIED_TERM_CODE_REF, $&
              when /\A\[([a-zA-Z0-9\(\)\._\-]+)::[ \t\n]*/
                @adl_type.push(:term_constraint)
                yield :START_TERM_CODE_CONSTRAINT, $1
              when /\A\[[a-zA-Z0-9][a-zA-Z0-9._\-]*\]/   #V_LOCAL_TERM_CODE_REF
                yield :V_LOCAL_TERM_CODE_REF, $&
              when /\A\[/   # [
                yield :Left_bracket_code, :Left_bracket_code
              when /\A\]/   # ]
                yield :Right_bracket_code, :Right_bracket_code
              when /\A[A-Z][a-zA-Z0-9_]*<[a-zA-Z0-9,_<>]+>/   #V_GENERIC_TYPE_IDENTIFIER
                yield :V_GENERIC_TYPE_IDENTIFIER, $&
              when /\A[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X][T\t][hH?X][hH?X]:[mM?X][mM?X]:[sS?X][sS?X]/
                yield :V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN, $&
              when /\A[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X]/
                yield :V_ISO8601_DATE_CONSTRAINT_PATTERN, $&
              when /\A[hH][hH]:[mM?X][mM?X]:[sS?X][sS?X]/
                yield :V_ISO8601_TIME_CONSTRAINT_PATTERN, $&
              when /\A[a-z][a-zA-Z0-9_]*/
                word = $&.dup
                if RESERVED[word.downcase]
                  yield RESERVED[word.downcase], RESERVED[word.downcase]
                else
                  @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: V_ATTRIBUTE_IDENTIFIER = #{word} at #{@filename}:#{@lineno}")
                  yield :V_ATTRIBUTE_IDENTIFIER, word #V_ATTRIBUTE_IDENTIFIER /\A[a-z][a-zA-Z0-9_]*/
                end
              when /\A[A-Z][a-zA-Z0-9_]*/
                word = $&.dup
                if RESERVED[word.downcase]
                  yield RESERVED[word.downcase], RESERVED[word.downcase]
                else
                  yield :V_TYPE_IDENTIFIER, $&
                end
              when /\Aa[ct][0-9.]+/   #V_LOCAL_CODE
                yield :V_LOCAL_CODE, $&
              when /\A[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?|[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9](Z|[+-][0-9]{4})?/   #V_ISO8601_EXTENDED_DATE_TIME YYYY-MM-DDThh:mm:ss[,sss][Z|+/- -n-n-n-n-]-
                yield :V_ISO8601_EXTENDED_DATE_TIME, $&
              when /\A[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})? /   #V_ISO8601_EXTENDED_TIME hh:mm:ss[,sss][Z|+/-nnnn]
                yield :V_ISO8601_EXTENDED_TIME, $&
              when /\A[0-9]{4}-[0-1][0-9]-[0-3][0-9]|[0-9]{4}-[0-1][0-9]/   #V_ISO8601_EXTENDED_DATE YYYY-MM-DD
                yield :V_ISO8601_EXTENDED_DATE, $&
              when /\A[0-9]+|[0-9]+[eE][+-]?[0-9]+/   #V_INTEGER
                yield :V_INTEGER, $&
              when /\A[0-9]+\.[0-9]+|[0-9]+\.[0-9]+[eE][+-]?[0-9]+ /   #V_REAL
                yield :V_REAL, $&
              when /\A"((?:[^"\\]+|\\.)*)"/ #V_STRING
              when /\A"([^"]*)"/m #V_STRING
                yield :V_STRING, $1
              when /\A[a-z]+:\/\/[^<>|\\{}^~"\[\] ]*/ #V_URI
                yield :V_URI, $&
              when /\A\S/ #UTF8CHAR
                yield :UTF8CHAR, $&
              else
                raise
              end
              data = $' # variable $' receives the string after the match
            else
              raise
            end
          end # of until
        end
      end # of 

      class DADLScanner < Base
        @@logger = Logger.new('log/scanner.log')
        RESERVED = {
          'true' => :SYM_TRUE, #[Tt][Rr][Uu][Ee] -- -> SYM_TRUE 
          'false' => :SYM_FALSE, # [Ff][Aa][Ll][Ss][Ee] -- -> SYM_FALSE 
          'infinity' => :SYM_INFINITY # [Ii][Nn][Ff][Ii][Nn][Ii][Tt][Yy] -- -> SYM_INFINITY 
        }

        def initialize(adl_type, filename, lineno = 1)
          super(adl_type, filename, lineno)
          @dadl_root_scanner = OpenEHR::ADL::Scanner::DADL::RootScanner.new
          @in_c_domain_type = false

          @adl_scanner = lambda{OpenEHR::ADL::Scanner::ADLScanner.new(adl_type, filename)}
          @cadl_scanner = lambda{OpenEHR::ADL::Scanner::CADLScanner.new(adl_type, filename)}
          @regex_scanner = lambda{OpenEHR::ADL::Scanner::RegexScanner.new(adl_type, filename)}
          @term_constraint_scanner = lambda{OpenEHR::ADL::Scanner::TermConstraintScanner.new(adl_type, filename)}
        end


        def scan(data)
          @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_dadl at #{@filename}:#{@lineno}: data = #{data.inspect}")
          until data.nil?  do
            case @adl_type.last
            when :adl
              data = @adl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :cadl
              data = @cadl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :regexp
              data = @regex_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :term_constraint
              @@logger.debug("#{__FILE__}:#{__LINE__}: scan_dadl: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")

              data = @term_constraint_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :dadl
#               case scanned = @dadl_root_scanner.parse(data)
#               when Yaparc::Result::OK
#                 yield scanned.value
#                 data = scanned.input
#               else
#               end

              case data
              when /\A\n/ # carriage return
                @lineno += 1
                ;
              when /\A[ \t\r\f]+/ #just drop it
                ;
              when /\A--.*\n/ # single line comment
                @lineno += 1
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_dadl: COMMENT = #{$&} at #{@filename}:#{@lineno}")
                ;
                ###----------/* symbols */ ------------------------------------------------- 
              when /\A\=/   # =
                yield :SYM_EQ, :SYM_EQ
              when /\A\>\=/   # >=
                yield :SYM_GE, :SYM_GE
              when /\A\<\=/   # <=
                yield :SYM_LE, :SYM_LE
              when /\A\</   # <
                if @in_interval
                  yield :SYM_LT, :SYM_LT
                else
                  @adl_type.push(:dadl)
                  yield :SYM_START_DBLOCK, :SYM_START_DBLOCK
                end
              when /\A\>/   # >
                if @in_interval
                  yield :SYM_GT, :SYM_GT
                elsif @in_c_domain_type == true
                  assert_at(__FILE__,__LINE__){@adl_type.last == :dadl}
                  adl_type = @adl_type.pop
                  if @adl_type.last == :cadl
                    @in_c_domain_type = false
                    yield :END_V_C_DOMAIN_TYPE_BLOCK, $&
                  else
                    yield :SYM_END_DBLOCK, $&
                  end
                elsif @in_c_domain_type == false
                  adl_type = @adl_type.pop
                  assert_at(__FILE__,__LINE__){adl_type == :dadl}
                  yield :SYM_END_DBLOCK, $&
                else
                  raise
                end
              when /\A\-/   # -
                yield :Minus_code, :Minus_code
              when /\A\+/   # +
                yield :Plus_code, :Plus_code
              when /\A\*/   # *
                yield :Star_code, :Star_code
              when /\A\//   # /
                yield :Slash_code, :Slash_code
              when /\A\^/   # ^
                yield :Caret_code, :Caret_code
              when /\A\.\.\./   # ...
                yield :SYM_LIST_CONTINUE, :SYM_LIST_CONTINUE
              when /\A\.\./   # ..
                yield :SYM_ELLIPSIS, :SYM_ELLIPSIS
              when /\A\./   # .
                yield :Dot_code, :Dot_code
              when /\A\;/   # ;
                yield :Semicolon_code, :Semicolon_code
              when /\A\,/   # ,
                yield :Comma_code, :Comma_code
              when /\A\:/   # :
                yield :Colon_code, :Colon_code
              when /\A\!/   # !
                yield :Exclamation_code, :Exclamation_code
              when /\A\(/   # (
                yield :Left_parenthesis_code, :Left_parenthesis_code
              when /\A\)/   # )
                yield :Right_parenthesis_code, :Right_parenthesis_code
              when /\A\$/   # $
                yield :Dollar_code, :Dollar_code
              when /\A\?\?/   # ??
                yield :SYM_DT_UNKNOWN, :SYM_DT_UNKNOWN
              when /\A\?/   # ?
                yield :Question_mark_code, :Question_mark_code
              when /\A\|/   # |
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_dadl: @in_interval = #{@in_interval} at #{@filename}:#{@lineno}")
                if @in_interval
                  @in_interval = false
                else
                  #          @in_interval = false
                  @in_interval = true
                end
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_dadl: SYM_INTERVAL_DELIM at #{@filename}:#{@lineno}")
                yield :SYM_INTERVAL_DELIM, :SYM_INTERVAL_DELIM
              when /\A\[/   # [
                yield :Left_bracket_code, :Left_bracket_code
              when /\A\]/   # ]
                yield :Right_bracket_code, :Right_bracket_code
              when /\A[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?|[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9](Z|[+-][0-9]{4})?/   #V_ISO8601_EXTENDED_DATE_TIME YYYY-MM-DDThh:mm:ss[,sss][Z|+/- -n-n-n-n-]-
                yield :V_ISO8601_EXTENDED_DATE_TIME, $&
              when /\A[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})? /   #V_ISO8601_EXTENDED_TIME hh:mm:ss[,sss][Z|+/-nnnn]
                yield :V_ISO8601_EXTENDED_TIME, $&
              when /\A[0-9]{4}-[0-1][0-9]-[0-3][0-9]|[0-9]{4}-[0-1][0-9]/   #V_ISO8601_EXTENDED_DATE YYYY-MM-DD
                yield :V_ISO8601_EXTENDED_DATE, $&
              when /\A[A-Z][a-zA-Z0-9_]*<[a-zA-Z0-9,_<>]+>/   #V_GENERIC_TYPE_IDENTIFIER
                yield :V_GENERIC_TYPE_IDENTIFIER, $&
              when /\A[0-9]+|[0-9]+[eE][+-]?[0-9]+/   #V_INTEGER
                yield :V_INTEGER, $&
              when /\A[a-z]+:\/\/[^<>|\\{}^~"\[\] ]*/ #V_URI
                yield :V_URI, $&
              when /\A\S/ #UTF8CHAR
                yield :UTF8CHAR, $&
              end
              data = $' # variable $' receives the string after the match
            else
              raise
            end
          end
        end
      end

      class RegexScanner < Base
        def initialize(adl_type, filename, lineno = 1)
          super(adl_type, filename, lineno)
          @adl_scanner = lambda{OpenEHR::ADL::Scanner::ADLScanner.new(adl_type, filename)}
          @cadl_scanner = lambda{OpenEHR::ADL::Scanner::CADLScanner.new(adl_type, filename)}
          @dadl_scanner = lambda{OpenEHR::ADL::Scanner::DADLScanner.new(adl_type, filename)}
          @term_constraint_scanner = lambda{OpenEHR::ADL::Scanner::TermConstraintScanner.new(adl_type, filename)}
        end

        def scan(data)
          @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_regexp at #{@filename}:#{@lineno}: data = #{data.inspect}")
          until data.nil?  do
            case @adl_type.last
            when :regexp
              case data
              when /\A\/\}/ #V_REGEXP
                if @adl_type.last == :regexp
                  @in_regexp = false
                  @adl_type.pop
                  yield :END_REGEXP_BLOCK, :END_REGEXP_BLOCK
                else
                  raise
                end
              when /\A(.*)(\/\})/ #V_REGEXP
                yield :REGEXP_BODY, $1
                if @adl_type.last == :regexp
                  @in_regexp = false
                  @adl_type.pop
                  yield :END_REGEXP_BLOCK, :END_REGEXP_BLOCK
                else
                  raise
                end
              else
                raise data
              end
              data = $' # variable $' receives the string after the match
            when :adl
              data = @adl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :dadl
              data = @dadl_scanner.scan(data) do |sym, val|
                yield sym, val
              end
            when :cadl
              data = @cadl_scanner.scan(data) do |sym, val|
                yield sym, val
              end
            when :term_constraint
              @@logger.debug("#{__FILE__}:#{__LINE__}: scan_regexp: Entering scan_term_constraint at #{@filename}:#{@lineno}")
              data = @term_constraint_scanner.scan(data) do |sym, val|
                yield sym, val
              end
            else
              raise
            end
          end
        end
      end

      class TermConstraintScanner < Base
        def initialize(adl_type, filename, lineno = 1)
          super(adl_type, filename, lineno)
          @adl_scanner = lambda{OpenEHR::ADL::Scanner::ADLScanner.new(adl_type, filename)}
          @cadl_scanner = lambda{OpenEHR::ADL::Scanner::CADLScanner.new(adl_type, filename)}
          @dadl_scanner = lambda{OpenEHR::ADL::Scanner::DADLScanner.new(adl_type, filename)}
          @regex_scanner = lambda{OpenEHR::ADL::Scanner::RegexScanner.new(adl_type, filename)}
        end

        def scan(data)
          @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_term_constraint")
          until data.nil?  do
            case @adl_type.last
            when :term_constraint
              case data
              when /\A\n/ # carriage return
                @lineno += 1
                ;
              when /\A[ \t\r\f]+/ #just drop it
                ;
              when /\A--.*$/ # single line comment
                @lineno += 1
                #@@logger.debug("#{__FILE__}:#{__LINE__}: scan_term_constraint: COMMENT = #{$&} at #{@filename}:#{@lineno}")
                ;
              when /\A([a-zA-Z0-9\._\-])+[ \t]*,/ # match any line, with ',' termination
                yield :TERM_CODE, $1
              when /\A([a-zA-Z0-9\._\-])+[ \t]*;/ # match second last line with ';' termination (assumed value)
                yield :TERM_CODE, $1
              when /\A([a-zA-Z0-9\._\-])*[ \t]*\]/ # match final line, terminating in ']'
                adl_type = @adl_type.pop
                assert_at(__FILE__,__LINE__){adl_type == :term_constraint}
                yield :END_TERM_CODE_CONSTRAINT, $1
              else
                raise "data = #{data}"
              end
              data = $' # variable $' receives the string after the match
            when :adl
              data = @adl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :dadl
              data = @dadl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :cadl
              data = @cadl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            else
              raise
            end
          end
        end
      end

      class ADLScanner < Base
        attr_accessor :adl_type, :lineno, :cadl_scanner, :dadl_scanner, :regex_scanner, :term_constraint_scanner

        @@logger = Logger.new('log/scanner.log')
        RESERVED = {
          'archetype' => :SYM_ARCHETYPE,
          'adl_version' => :SYM_ADL_VERSION,
          'controlled' => :SYM_IS_CONTROLLED,
          'specialize' => :SYM_SPECIALIZE,
          'concept' => :SYM_CONCEPT,
          'language' => :SYM_LANGUAGE,
          'description' => :SYM_DESCRIPTION,
          'definition' => :SYM_DEFINITION,
          'invariant' => :SYM_INVARIANT,
          'ontology' => :SYM_ONTOLOGY,
          'matches' => :SYM_MATCHES,
          'is_in' => :SYM_MATCHES,
          'occurrences' => :SYM_OCCURRENCES,
          'true' => :SYM_TRUE, #[Tt][Rr][Uu][Ee] -- -> SYM_TRUE 
          'false' => :SYM_FALSE, # [Ff][Aa][Ll][Ss][Ee] -- -> SYM_FALSE 
          'infinity' => :SYM_INFINITY # [Ii][Nn][Ff][Ii][Nn][Ii][Tt][Yy] -- -> SYM_INFINITY 
        }

        def initialize(adl_type, filename, lineno = 1)
          super(adl_type, filename, lineno)
          @cadl_scanner = lambda{OpenEHR::ADL::Scanner::CADLScanner.new(adl_type, filename)}
          @dadl_scanner = lambda{OpenEHR::ADL::Scanner::DADLScanner.new(adl_type, filename)}
          @regex_scanner = lambda{OpenEHR::ADL::Scanner::RegexScanner.new(adl_type, filename)}
          @term_constraint_scanner = lambda{OpenEHR::ADL::Scanner::TermConstraintScanner.new(adl_type, filename)}
        end

        def scan(data)
          @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_adl at #{@filename}:#{@lineno}: data = #{data.inspect}")
          until data.nil?  do
            case @adl_type.last
            when :dadl
              data = @dadl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :cadl
              data = @cadl_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :regexp
              data = @regex_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :term_constraint
              @@logger.debug("#{__FILE__}:#{__LINE__}: scan_adl: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")

              data = @term_constraint_scanner.call.scan(data) do |sym, val|
                yield sym, val
              end
            when :adl
              case data
              when /\A\n/ # carriage return
                @lineno += 1
                ;
              when /\A[ \t\r\f]+/ #just drop it
                ;
              when /\A--.*\n/ # single line comment
                @lineno += 1
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_adl: COMMENT = #{$&} at #{@filename}:#{@lineno}")
                ;
              when /\Adescription/   # description
                yield :SYM_DESCRIPTION, :SYM_DESCRIPTION
              when /\Adefinition/   # definition
                yield :SYM_DEFINITION, :SYM_DEFINITION
                ###----------/* symbols */ ------------------------------------------------- 
              when /\A[A-Z][a-zA-Z0-9_]*/
                yield :V_TYPE_IDENTIFIER, $&
                #      when /\A[a-zA-Z][a-zA-Z0-9_-]+\.[a-zA-Z][a-zA-Z0-9_-]+\.[a-zA-Z0-9]+/   #V_ARCHETYPE_ID
              when /\A(\w+)-(\w+)-(\w+)\.(\w+)(-\w+)?\.(v\w+)/   #V_ARCHETYPE_ID
                object_id, rm_originator, rm_name, rm_entity, concept_name, specialisation, version_id = $&, $1, $2, $3, $4, $5, $6
                archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new(object_id, concept_name, rm_name, rm_entity, rm_originator, specialisation, version_id)
                #        yield :V_ARCHETYPE_ID, $&
                yield :V_ARCHETYPE_ID, archetype_id
              when /\A[a-z][a-zA-Z0-9_]*/
                #        word = $&.downcase
                word = $&
                if RESERVED[word]
                  @@logger.debug("#{__FILE__}:#{__LINE__}: scan_adl: RESERVED = #{RESERVED[word]} at #{@filename}:#{@lineno}")
                  yield RESERVED[word], RESERVED[word]
                elsif #/\A[A-Z][a-zA-Z0-9_]*/
                  @@logger.debug("#{__FILE__}:#{__LINE__}: scan_adl: V_ATTRIBUTE_IDENTIFIER = #{$&} at #{@filename}:#{@lineno}")
                  yield :V_ATTRIBUTE_IDENTIFIER, $&
                end
              when /\A\=/   # =
                yield :SYM_EQ, :SYM_EQ
              when /\A\>=/   # >=
                yield :SYM_GE, :SYM_GE
              when /\A\<=/   # <=
                yield :SYM_LE, :SYM_LE
              when /\A\</   # <
                if @in_interval                   # @start_block_received = false
                  yield :SYM_LT, :SYM_LT
                else                              # @start_block_received = true
                  @adl_type.push(:dadl)
                  yield :SYM_START_DBLOCK,  $&
                end
              when /\A\>/   # >
                if @in_interval
                  yield :SYM_GT, :SYM_GT
                else
                  adl_type = @adl_type.pop
                  assert_at(__FILE__,__LINE__){adl_type == :dadl}
                  yield :SYM_END_DBLOCK, :SYM_END_DBLOCK
                end
              when /\A\{/   # {
                @adl_type.push(:cadl)
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: entering cADL at #{@filename}:#{@lineno}")
                yield :SYM_START_CBLOCK, :SYM_START_CBLOCK
              when /\A\}/   # }
                adl_type = @adl_type.pop
                assert_at(__FILE__,__LINE__){adl_type == :cadl}
                @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: exiting cADL at #{@filename}:#{@lineno}")
                yield :SYM_END_CBLOCK, $&
              when /\A\-/   # -
                yield :Minus_code, :Minus_code
              when /\A\+/   # +
                yield :Plus_code, :Plus_code
              when /\A\*/   # *
                yield :Star_code, :Star_code
              when /\A\//   # /
                yield :Slash_code, :Slash_code
              when /\A\^/   # ^
                yield :Caret_code, :Caret_code
              when /\A\=/   # =
                yield :Equal_code, :Equal_code
              when /\A\.\.\./   # ...
                yield :SYM_LIST_CONTINUE, :SYM_LIST_CONTINUE
              when /\A\.\./   # ..
                yield :SYM_ELLIPSIS, :SYM_ELLIPSIS
              when /\A\./   # .
                yield :Dot_code, :Dot_code
              when /\A\;/   # ;
                yield :Semicolon_code, :Semicolon_code
              when /\A\,/   # ,
                yield :Comma_code, :Comma_code
              when /\A\:/   # :
                yield :Colon_code, :Colon_code
              when /\A\!/   # !
                yield :Exclamation_code, :Exclamation_code
              when /\A\(/   # (
                yield :Left_parenthesis_code, :Left_parenthesis_code
              when /\A\)/   # )
                yield :Right_parenthesis_code, :Right_parenthesis_code
              when /\A\$/   # $
                yield :Dollar_code, :Dollar_code
              when /\A\?\?/   # ??
                yield :SYM_DT_UNKNOWN, :SYM_DT_UNKNOWN
              when /\A\?/   # ?
                yield :Question_mark_code, :Question_mark_code
              when /\A[0-9]+\.[0-9]+(\.[0-9]+)*/   # ?
                yield :V_VERSION_STRING, $&
              when /\A\|/   # |
                if @in_interval
                  @in_interval = false
                else
                  @in_interval = true
                end
                yield :SYM_INTERVAL_DELIM, :SYM_INTERVAL_DELIM
              when /\A\[[a-zA-Z0-9()\._-]+::[a-zA-Z0-9\._-]+\]/
                #      when /\A\[[a-zA-Z0-9()\._-]+\:\:[a-zA-Z0-9\._-]+\]/   #V_QUALIFIED_TERM_CODE_REF form [ICD10AM(1998)::F23]
                yield :V_QUALIFIED_TERM_CODE_REF, $&
              when /\A\[[a-zA-Z0-9][a-zA-Z0-9._\-]*\]/   #V_LOCAL_TERM_CODE_REF
                yield :V_LOCAL_TERM_CODE_REF, $&
              when /\A\[/   # [
                yield :Left_bracket_code, :Left_bracket_code
              when /\A\]/   # ]
                yield :Right_bracket_code, :Right_bracket_code

              when /\A"([^"]*)"/m #V_STRING
                yield :V_STRING, $1
              when /\A\[[a-zA-Z0-9._\- ]+::[a-zA-Z0-9._\- ]+\]/   #ERR_V_QUALIFIED_TERM_CODE_REF
                yield :ERR_V_QUALIFIED_TERM_CODE_REF, $&
              when /\Aa[ct][0-9.]+/   #V_LOCAL_CODE
                yield :V_LOCAL_CODE, $&
              when /\A[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?|[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9](Z|[+-][0-9]{4})?/   #V_ISO8601_EXTENDED_DATE_TIME YYYY-MM-DDThh:mm:ss[,sss][Z|+/- -n-n-n-n-]-
                yield :V_ISO8601_EXTENDED_DATE_TIME, $&
              when /\A[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})? /   #V_ISO8601_EXTENDED_TIME hh:mm:ss[,sss][Z|+/-nnnn]
                yield :V_ISO8601_EXTENDED_TIME, $&
              when /\A[0-9]{4}-[0-1][0-9]-[0-3][0-9]|[0-9]{4}-[0-1][0-9]/   #V_ISO8601_EXTENDED_DATE YYYY-MM-DD
                yield :V_ISO8601_EXTENDED_DATE, $&
              when /\A[A-Z][a-zA-Z0-9_]*<[a-zA-Z0-9,_<>]+>/   #V_GENERIC_TYPE_IDENTIFIER
                yield :V_GENERIC_TYPE_IDENTIFIER, $&
              when /\A[0-9]+|[0-9]+[eE][+-]?[0-9]+/   #V_INTEGER
                yield :V_INTEGER, $&
              when /\A[0-9]+\.[0-9]+|[0-9]+\.[0-9]+[eE][+-]?[0-9]+ /   #V_REAL
                yield :V_REAL, $&
                #    when /\A"((?:[^"\\]+|\\.)*)"/ #V_STRING
              when /\A[a-z]+:\/\/[^<>|\\{}^~"\[\] ]*/ #V_URI
                yield :V_URI, $&
              when /\AP([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?T([0-9]+[hH])?([0-9]+[mM])?([0-9]+[sS])?|P([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?/   #V_ISO8601_DURATION PnYnMnWnDTnnHnnMnnS
                yield :V_ISO8601_DURATION, $&
              when /\A\S/ #UTF8CHAR
                yield :UTF8CHAR, $&
              end
              data = $' # variable $' receives the string after the match
            else
              raise
            end
          end
        end
      end


      module Common
        class START_TERM_CODE_CONSTRAINT
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/[ \t\n]*\[([a-zA-Z0-9\(\)\._\-]+)::[ \t\n]*/)) do |match|
                OpenEHR::LOG.info("START_TERM_CODE_CONSTRAINT: #{match}")
                [:START_TERM_CODE_CONSTRAINT, match]
              end
            end
          end
        end

        # /\A\[[a-zA-Z0-9()\._-]+::[a-zA-Z0-9\._-]+\]/  #V_QUALIFIED_TERM_CODE_REF form [ICD10AM(1998)::F23]
        class V_QUALIFIED_TERM_CODE_REF
          include Yaparc::Parsable
          def initialize
            @parser = lambda do |input|
              Yaparc::Apply.new(Yaparc::Regex.new(/\A\[[a-zA-Z0-9()\._-]+::[a-zA-Z0-9\._-]+\]/)) do |match|
                OpenEHR::LOG.info("V_QUALIFIED_TERM_CODE_REF: #{match}")
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
                OpenEHR::LOG.info("V_TERM_CODE_REF: #{match}")
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
                OpenEHR::LOG.info("ERR_V_QUALIFIED_TERM_CODE_REF: #{match}")
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
                OpenEHR::LOG.info("V_TYPE_IDENTIFIER: #{match}")
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
                OpenEHR::LOG.info("V_GENERIC_TYPE_IDENTIFIER: #{match}")
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
                OpenEHR::LOG.info("V_LOCAL_CODE: #{match}")
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
                OpenEHR::LOG.info("V_STRING: #{match}")
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
                OpenEHR::LOG.info("V_REAL: #{match}")
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
                OpenEHR::LOG.info("V_ISO8601_DURATION: #{match}")
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
        #
        # DADL::RootScanner
        #
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
                              OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION.new#,
                              #OpenEHR::ADL::Scanner::Common::START_TERM_CODE_CONSTRAINT.new
                              )
            end
          end
        end

        #  <DADL::Reserved class>
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
                                OpenEHR::LOG.info("Reserved: #{match}")
                                [OpenEHR::ADL::Scanner::DADL::RESERVED[match], OpenEHR::ADL::Scanner::DADL::RESERVED[match]]
                              end,
                              Yaparc::Apply.new(Yaparc::Regex.new(/\A[a-z][a-zA-Z0-9_]*/)) do |match|
                                OpenEHR::LOG.info("V_ATTRIBUTE_IDENTIFIER: #{match}")
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
                OpenEHR::LOG.info("V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN: #{match}")
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
                OpenEHR::LOG.info("V_ISO8601_DATE_CONSTRAINT_PATTERN: #{match}")
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
                OpenEHR::LOG.info("V_ISO8601_TIME_CONSTRAINT_PATTERN: #{match}")
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
                OpenEHR::LOG.info("V_ISO8601_DURATION_CONSTRAINT_PATTERN: #{match}")
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
                OpenEHR::LOG.info("V_C_DOMAIN_TYPE: #{match}")
                [:START_V_C_DOMAIN_TYPE_BLOCK, match]
              end
            end
          end
        end

        #
        # CADL::RootScanner
        #
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
                              OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION.new#,
                              #OpenEHR::ADL::Scanner::Common::START_TERM_CODE_CONSTRAINT.new
                              )
            end
          end
        end

        # <CADL::Reserved class>
        class Reserved
          include Yaparc::Parsable
          
          def initialize
            @parser = lambda do |input|
              orderd_reserved = RESERVED.keys.sort{|x,y| y.length <=> x.length  }
              reserved_parsers = orderd_reserved.map do |keyword| 
                Yaparc::Literal.new(keyword,false)
              end
              Yaparc::Alt.new(Yaparc::Apply.new(Yaparc::Alt.new(*reserved_parsers)) do |match|
                                OpenEHR::LOG.info("Reserved: #{match}")
                                [OpenEHR::ADL::Scanner::CADL::RESERVED[match], OpenEHR::ADL::Scanner::CADL::RESERVED[match]]
                              end,
                              Yaparc::Apply.new(Yaparc::Regex.new(/\A[a-z][a-zA-Z0-9_]*/)) do |match|
                                OpenEHR::LOG.info("V_ATTRIBUTE_IDENTIFIER: #{match}")
                                [:V_ATTRIBUTE_IDENTIFIER, match]
                              end)
            end
          end
        end

      end
    end
  end
end
