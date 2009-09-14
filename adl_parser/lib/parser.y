
class OpenEHR::ADL::Parser

#options omit_action_call

prechigh

  nonassoc UMINUS UPLUS
  left '*' '/'
  left '+' '-'

  nonassoc SYM_EQ
  nonassoc SYM_NE
  nonassoc SYM_LT
  nonassoc SYM_START_DBLOCK
  nonassoc SYM_START_CBLOCK
  nonassoc SYM_GT
  nonassoc SYM_END_CBLOCK
  nonassoc SYM_END_DBLOCK
  nonassoc SYM_LE
  nonassoc SYM_GE

preclow


rule
### http://svn.openehr.org/ref_impl_eiffel/TRUNK/components/adl_parser/src/syntax/adl/parser/adl_validator.y

input: archetype EOF
  { 
    result = val[0]
  }
  | error

archetype: arch_identification arch_specialisation arch_concept arch_language arch_description arch_definition arch_invariant arch_ontology
  { 
    assert_at(__FILE__,__LINE__) do
      val[4].instance_of?(OpenEHR::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION) and val[5].instance_of?(OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT) and val[7].instance_of?(OpenEHR::AM::Archetype::Ontology::ARCHETYPE_ONTOLOGY) 
    end
    
    archetype_id = val[0][:archetype_id]
    parent_archtype_id = val[1][:parent_archtype_id] if val[1]
    adl_version = val[0][:arch_head][:arch_meta_data][:adl_version]
    concept = val[2]
    language = val[3][:arch_language]
    archetype = OpenEHR::AM::Archetype::ARCHETYPE.create(
                                                         :archetype_id => archetype_id,
                                                         :parent_archtype_id => parent_archtype_id,
                                                         :adl_version => adl_version,
                                                         :concept => concept,
                                                         :description => val[4],
                                                         :definition => val[5],
                                                         :ontology => val[7]
                                                         ) do |archetype|
      archetype.original_language = language
    end
    @@logger.debug("#{__FILE__}:#{__LINE__}: archetype = #{archetype} at #{@filename}:#{@lineno}")
    result = archetype
  }


arch_identification: arch_head V_ARCHETYPE_ID
  { 
    result = {:arch_head => val[0], :archetype_id => val[1] }
  }
  | SYM_ARCHETYPE error
  { 
    raise
  }

arch_head: SYM_ARCHETYPE
  { 
    result = {:arch_meta_data => nil }
  }
  | SYM_ARCHETYPE arch_meta_data
  { 
    result = val[1]
  }

arch_meta_data: Left_parenthesis_code arch_meta_data_items Right_parenthesis_code
  { 
    result = {:arch_meta_data => val[1] }
  }

arch_meta_data_items: arch_meta_data_item
  { 
    result = val[0]
  }
  | arch_meta_data_items Semicolon_code arch_meta_data_item
  { 
    result = val[0].merge(val[2])
  }


arch_meta_data_item: SYM_ADL_VERSION SYM_EQ V_VERSION_STRING
  { 
    result = {:adl_version => val[2], :is_controlled => false }
  }
  | SYM_IS_CONTROLLED
  { 
    result = {:is_controlled => true }
  }

# Define specialization in which its constraints are narrower than those of the parent.
# Any data created via the use of the specialized archetype shall be conformant both to it and its parent.
arch_specialisation: #-- empty is ok
  | SYM_SPECIALIZE V_ARCHETYPE_ID
  {
    result = {:parent_archtype_id => val[1]}
  }
  | SYM_SPECIALIZE error

arch_concept: SYM_CONCEPT V_LOCAL_TERM_CODE_REF
  { 
    result = {:arch_concept => val[1] }
  }
  | SYM_CONCEPT error

#arch_language: #-- empty is ok for ADL 1.4 tools
#    | SYM_LANGUAGE V_DADL_TEXT
#  | SYM_LANGUAGE error

arch_language: #-- empty is ok for ADL 1.4 tools
  {
    result = {:arch_language => nil}
  }
    | SYM_LANGUAGE dadl_section
  {
    result = {:arch_language => val[1]}
  }
  | SYM_LANGUAGE error

#arch_description: #-- no meta-data ok
#    | SYM_DESCRIPTION V_DADL_TEXT
#  | SYM_DESCRIPTION error

arch_description: #-- no meta-data ok
    | SYM_DESCRIPTION dadl_section
  { 
    result = OpenEHR::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION.new(:details => val[1])
  }
  | SYM_DESCRIPTION error
  
#arch_definition: SYM_DEFINITION V_CADL_TEXT
#  | SYM_DEFINITION error
arch_definition: SYM_DEFINITION cadl_section
  { 
    result = val[1]
  }
  | SYM_DEFINITION error


### cADL section
cadl_section: c_complex_object
  {
    assert_at(__FILE__,__LINE__){val[0].instance_of?(OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT)}
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_complex_object = #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | assertions
  { 
    result = val[0]
  }
#  | error

#c_complex_object: c_complex_object_head SYM_MATCHES SYM_START_CBLOCK c_complex_object_body SYM_END_CBLOCK
c_complex_object: c_complx_object_head SYM_MATCHES START_REGEXP_BLOCK REGEXP_BODY END_REGEXP_BLOCK # added by akimichi
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT.create(:attributes => val[3]) do |c_complex_object|
      c_complex_object.node_id = val[0][:c_complex_object_id][:local_term_code_ref]
      c_complex_object.rm_type_name = val[0][:c_complex_object_id][:type_identifier]
      c_complex_object.occurrences = val[0][:c_occurrences]
    end
  }
    | c_complex_object_head SYM_MATCHES SYM_START_CBLOCK c_complex_object_body SYM_END_CBLOCK
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT.create(:attributes => val[3]) do |c_complex_object|
      c_complex_object.node_id = val[0][:c_complex_object_id][:local_term_code_ref]
      c_complex_object.rm_type_name = val[0][:c_complex_object_id][:type_identifier]
      c_complex_object.occurrences = val[0][:c_occurrences]
    end
  }
#    | c_complex_object_head error SYM_END_CBLOCK
#    | c_complex_object_head SYM_MATCHES SYM_START_CBLOCK c_complex_object_body c_invariants SYM_END_CBLOCK

c_complex_object_head: c_complex_object_id c_occurrences
  {
    result = {:c_complex_object_id => val[0], :c_occurrences => val[1]}
  }

c_complex_object_id: type_identifier
  {
    result = {:type_identifier => val[0]}
  }
  | type_identifier V_LOCAL_TERM_CODE_REF
  {
    result = {:type_identifier => val[0], :local_term_code_ref => val[1]}
  }

c_complex_object_body: c_any #-- used to indicate that any value of a type is ok
  | c_attributes
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT.new(:attributes => val[0])
  }


#------------------------- node types -----------------------
### http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/components/adl_parser/src/syntax/cadl/parser/cadl_validator.html
### c_object:  c_complex_object
### | archetype_internal_ref
### | archetype_slot
### | constraint_ref
### | c_code_phrase
### | c_ordinal
### | c_primitive_object
### | V_C_DOMAIN_TYPE
### | ERR_C_DOMAIN_TYPE
### | error
c_object: c_complex_object
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_complex_object = #{val[0].inspect} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | archetype_internal_ref
  {
    result = OpenEHR::AM::Archetype::Constraint_Model::ARCHETYPE_INTERNAL_REF.create do |archetype_internal_ref|
      archetype_internal_ref.target_path = val[0][:absolute_path]
      archetype_internal_ref.rm_type_name = val[0][:type_identifier]
      archetype_internal_ref.occurrences = val[0][:c_occurrences]
    end
  }
  | archetype_slot
  {
    result = val[0]
  }
  | constraint_ref
  {
    result = OpenEHR::AM::Archetype::Constraint_Model::CONSTRAINT_REF.create do |constraint_ref|
      constraint_ref.reference = val[0]
    end
  }
  | c_code_phrase
  {
    result = val[0]
  }
  | c_ordinal
  {
    result = val[0]
  }
  | c_primitive_object
  {
    result = val[0]
  }
  | v_c_domain_type
  {
    result = val[0]
  }

#  | v_c_domain_type
#  | V_C_DOMAIN_TYPE
  #   this is an attempt to match a dADL section inside cADL. It will
  #   probably never work 100% properly since there can be '>' inside "||"
  #   ranges, and also strings containing any character, e.g. units string
  #   contining "{}" chars. The real solution is to use the dADL parser on
  #   the buffer from the current point on and be able to fast-forward the
  #   cursor to the last character matched by the dADL scanner
  | ERR_C_DOMAIN_TYPE
  | error

v_c_domain_type: START_V_C_DOMAIN_TYPE_BLOCK dadl_section END_V_C_DOMAIN_TYPE_BLOCK
  { 
    result = val[1]
  }

# 'archetype_internal_ref' is a node that refers to a previously defined object node in the same archetype.
archetype_internal_ref: SYM_USE_NODE type_identifier c_occurrences absolute_path
  {
    result = {:type_identifier => val[1], :c_occurrences => val[2], :absolute_path => val[3] }
  }
  | SYM_USE_NODE type_identifier error

# 'archetype_slot' is a node whose statements define a constraint that determines which other archetypes may appear at that point in the current archetype.
archetype_slot: c_archetype_slot_head SYM_MATCHES SYM_START_CBLOCK c_includes c_excludes SYM_END_CBLOCK
  {
    result = OpenEHR::AM::Archetype::Constraint_Model::ARCHETYPE_SLOT.create do |archetype_slot|
      archetype_slot.includes = val[3]
      archetype_slot.excludes = val[4]
      archetype_slot.rm_type_name = val[0][:c_archetype_slot_id]
      archetype_slot.occurrences = val[0][:c_occurrences]
    end
  }
c_archetype_slot_head: c_archetype_slot_id c_occurrences
  {
    result = {:c_archetype_slot_id => val[0],:c_occurrences => val[1]}
  }

c_archetype_slot_id: SYM_ALLOW_ARCHETYPE type_identifier
  {
    result = val[1]
  }
  | SYM_ALLOW_ARCHETYPE type_identifier V_LOCAL_TERM_CODE_REF
  | SYM_ALLOW_ARCHETYPE error

# 'c_primitive_object' is an node representing a constraint on a primitive object type.
c_primitive_object: c_primitive
  {
    assert_at(__FILE__,__LINE__){val[0].kind_of?(OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_PRIMITIVE)}
    result = OpenEHR::AM::Archetype::Constraint_Model::C_PRIMITIVE_OBJECT.create do |c_primitive_object|
      c_primitive_object.item = val[0]
    end
  }

c_primitive: c_integer
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_integer = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_INTEGER.create do |c_integer|
      c_integer.list
      c_integer.range
      c_integer.assumed_value
    end
  }
  | c_real
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_real = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_REAL.new
  }
  | c_date
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_date = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_DATE.new
  }
  | c_time
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_time = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_TIME.new
  }
  | c_date_time
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_date_time = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_DATE_TIME.new
  }
  | c_duration
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_duration = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_DURATION.new
  }
  | c_string
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_string = #{val[0]} at #{@filename}:#{@lineno}")
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_STRING.new
  }
  | c_boolean
  {
    assert_at(__FILE__,__LINE__){val[0].instance_of?(OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN)}
    @@logger.debug("#{__FILE__}:#{__LINE__}: c_boolean = #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

c_any: Star_code
#c_any: '*'

#---------------- BODY - relationships ----------------

c_attributes: c_attribute
  { 
    result = [val[0]]
  }
  | c_attributes c_attribute
  { 
    result = (val[0] << val[1])
  }

# 'c_attribute' is a node representing a constraint on an attribute in an object model.
c_attribute: c_attr_head SYM_MATCHES SYM_START_CBLOCK c_attr_values SYM_END_CBLOCK
  { 
    assert_at(__FILE__,__LINE__){ val[0].kind_of?(OpenEHR::AM::Archetype::Constraint_Model::C_ATTRIBUTE)}
    c_attribute = val[0]
    c_attribute.children = val[3]
    result = c_attribute
  }
  | c_attr_head SYM_MATCHES START_REGEXP_BLOCK REGEXP_BODY END_REGEXP_BLOCK # added by akimichi
  { 
    assert_at(__FILE__,__LINE__){ val[0].kind_of?(OpenEHR::AM::Archetype::Constraint_Model::C_ATTRIBUTE)}
    result = val[0]
  }
  | c_attr_head SYM_MATCHES SYM_START_CBLOCK error SYM_END_CBLOCK
  { 
    assert_at(__FILE__,__LINE__){ val[0].kind_of?(OpenEHR::AM::Archetype::Constraint_Model::C_ATTRIBUTE)}
    result = val[0]
  }


c_attr_head: V_ATTRIBUTE_IDENTIFIER c_existence
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: V_ATTRIBUTE_IDENTIFIER = #{val[0]}, c_existence = #{val[1]} at #{@filename}")
    result = OpenEHR::AM::Archetype::Constraint_Model::C_SINGLE_ATTRIBUTE.new(
                                                                              :rm_attribute_name => val[0],
                                                                              :existence => val[1]
                                                                              )

  }
  | V_ATTRIBUTE_IDENTIFIER c_existence c_cardinality
  {
    assert_at(__FILE__,__LINE__){ val[2].instance_of?(OpenEHR::AM::Archetype::Constraint_Model::CARDINALITY) }
    @@logger.debug("#{__FILE__}:#{__LINE__}: V_ATTRIBUTE_IDENTIFIER: #{val[0]}, c_existence = #{val[1]}, c_cardinality = #{val[2]} at #{@filename}") 
    result = OpenEHR::AM::Archetype::Constraint_Model::C_MULTIPLE_ATTRIBUTE.new(
                                                                                :rm_attribute_name => val[0],
                                                                                :existence => val[1],
                                                                                :cardinality => val[2]
                                                                                )
  }

c_attr_values: c_object
  { 
    result = Array[val[0]]
  }
  | c_attr_values c_object
  { 
    result = (val[0] << val[1])
  }
  | c_any #	-- to allow a property to have any value
  { 
    result = Array[val[0]]
  }

### c_includes: #-- Empty
###     | SYM_INCLUDE assertions
c_includes: #-- Empty
    | SYM_INCLUDE invariants
{
    result = val[1]
}

### c_excludes: #-- Empty
###     | SYM_EXCLUDE assertions
c_excludes: #-- Empty
    | SYM_EXCLUDE invariants
{
    result = val[1]
}

invariants: invariant
  | invariants invariant

invariant: any_identifier ':' boolean_expression
  | boolean_expression
  | any_identifier ':' error

arch_invariant: #-- no invariant ok
    | SYM_INVARIANT V_ASSERTION_TEXT
    | SYM_INVARIANT error

# define all linguistic entries in this part as dADL.
#arch_ontology: SYM_ONTOLOGY V_DADL_TEXT
#  | SYM_ONTOLOGY error

arch_ontology: SYM_ONTOLOGY dadl_section
  { 
    dadl_section = val[1]
    result = OpenEHR::AM::Archetype::Ontology::ARCHETYPE_ONTOLOGY.new
  }
  | SYM_ONTOLOGY error


### dADL section
dadl_section: dadl_input

dadl_input: attr_vals
  | complex_object_block
#  | error

attr_vals: attr_val
  {
    result = Array[val[0]]
  }
  | attr_vals attr_val
  {
    result = (val[0] << val[1])
  }
  | attr_vals Semicolon_code attr_val
  {
    result = (val[0] << val[2])
  }

attr_val: attr_id SYM_EQ object_block
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: attr_id = #{val[0]} at #{@filename}:#{@lineno}")
    result = {:attr_id => val[0], :object_block => val[2]}
  }

attr_id: V_ATTRIBUTE_IDENTIFIER
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: V_ATTRIBUTE_IDENTIFIER = #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | V_ATTRIBUTE_IDENTIFIER error

object_block: complex_object_block
  { 
    result = val[0]
  }
  | primitive_object_block
  { 
    result = val[0]
  }

complex_object_block: single_attr_object_block
  { 
    result = val[0]
  }
  | multiple_attr_object_block
  { 
    result = val[0]
  }

multiple_attr_object_block: untyped_multiple_attr_object_block
  { 
    result = {:untyped_multiple_attr_object_block => val[0]}
  }
  | type_identifier untyped_multiple_attr_object_block
  { 
    result = {:type_identifier => val[0], :untyped_multiple_attr_object_block => val[1]}
  }

untyped_multiple_attr_object_block: multiple_attr_object_block_head keyed_objects SYM_END_DBLOCK
  { 
    result = {:multiple_attr_object_block_head => val[0], :keyed_objects => val[1]}
  }

multiple_attr_object_block_head: SYM_START_DBLOCK
  { 
    @@logger.debug("SYM_START_DBLOCK: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

keyed_objects: keyed_object
  { 
    result = Array[val[0]]
  }
  | keyed_objects keyed_object
  { 
    result = (val[0] << val[1])
  }

keyed_object: object_key SYM_EQ object_block
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: keyed_object = #{val[0]} at #{@filename}:#{@lineno}")
    result = {:object_key => val[0], :object_block => val[1]}
  }

object_key: Left_bracket_code simple_value Right_bracket_code
  {
    @@logger.debug("object_key: [#{val[1]}] at #{@filename}:#{@lineno}")
    result = val[1]
  }

single_attr_object_block: untyped_single_attr_object_block
  {
    result = {:untyped_single_attr_object_block => val[0]}
  }
  | type_identifier untyped_single_attr_object_block
  {
    result = {:type_identifier => val[0], :untyped_single_attr_object_block => val[1]}
  }

untyped_single_attr_object_block: single_attr_object_complex_head SYM_END_DBLOCK # >
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: single_attr_object_complex_head = #{val[0]} at #{@filename}:#{@lineno}")
    result = {:single_attr_object_complex_head => val[0]}
  }
  | single_attr_object_complex_head attr_vals SYM_END_DBLOCK
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: attr_vals = #{val[1]} at #{@filename}:#{@lineno}")
    result = {:single_attr_object_complex_head => val[0], :attr_vals => val[1]}
  }
single_attr_object_complex_head: SYM_START_DBLOCK
primitive_object_block: untyped_primitive_object_block
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: untyped_primitive_object_block = #{val[0]} at #{@filename}:#{@lineno}")
    result = {:untyped_primitive_object_block => val[0]}
  }
  | type_identifier untyped_primitive_object_block
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: type_identifier = #{val[0]}, untyped_primitive_object_block = #{val[1]} at #{@filename}:#{@lineno}")
    result = {:type_identifier => val[0], :untyped_primitive_object_block => val[1]}
  }
untyped_primitive_object_block: SYM_START_DBLOCK primitive_object_value SYM_END_DBLOCK
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: primitive_object_block = <#{val[1]}> at #{@filename}:#{@lineno}")
    result = val[1]
  }
primitive_object_value: simple_value
  {
    result = val[0]
  }
  | simple_list_value
  {
    result = val[0]
  }
  | simple_interval_value
  {
    result = val[0]
  }
  | term_code
  {
    result = val[0]
  }
  | term_code_list_value
  {
    result = val[0]
  }
simple_value: string_value
  {
    @@logger.debug("string_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | integer_value
  {
    @@logger.debug("integer_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | real_value
  {
    @@logger.debug("real_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | boolean_value
  {
    @@logger.debug("boolean_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | character_value
  {
    @@logger.debug("character_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | date_value
  {
    @@logger.debug("date_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | time_value
  {
    @@logger.debug("time_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | date_time_value
  {
    @@logger.debug("date_time_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | duration_value
  {
    @@logger.debug("duration_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | uri_value
  {
    @@logger.debug("uri_value: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

simple_list_value: string_list_value
  | integer_list_value
  | real_list_value
  | boolean_list_value
  | character_list_value
  | date_list_value
  | time_list_value
  | date_time_list_value
  | duration_list_value

simple_interval_value: integer_interval_value
  | real_interval_value
  | date_interval_value
  | time_interval_value
  | date_time_interval_value
  | duration_interval_value

type_identifier: V_TYPE_IDENTIFIER
  {
    @@logger.debug("V_TYPE_IDENTIFIER: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }
  | V_GENERIC_TYPE_IDENTIFIER
  {
    @@logger.debug("V_GENERIC_TYPE_IDENTIFIER: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

string_value: V_STRING
  {
    @@logger.debug("V_STRING: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

string_list_value: V_STRING Comma_code V_STRING
  | string_list_value Comma_code V_STRING
  | V_STRING Comma_code SYM_LIST_CONTINUE

integer_value: V_INTEGER
  { 
    begin
      integer = Integer(val[0])
    rescue
      raise
    end
    result = integer
  }
  | Plus_code V_INTEGER
  {
    begin
      integer = Integer(val[0])
    rescue
      raise
    end
    result = integer
  }
  | Minus_code V_INTEGER
  {
    begin
      integer = Integer(val[0])
    rescue
      raise
    end
    result = - integer
  }
###   | '+' V_INTEGER
###   | '-' V_INTEGER

integer_list_value: integer_value Comma_code integer_value
  | integer_list_value Comma_code integer_value
  | integer_value Comma_code SYM_LIST_CONTINUE

integer_interval_value: SYM_INTERVAL_DELIM integer_value SYM_ELLIPSIS integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT integer_value SYM_ELLIPSIS integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM integer_value SYM_ELLIPSIS SYM_LT integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT integer_value SYM_ELLIPSIS SYM_LT integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LT integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LE integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GE integer_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM integer_value SYM_INTERVAL_DELIM

real_value: V_REAL
  {
    begin
      real = Float(val[0])
    rescue
      raise
    end
    result = real
  }
  | Plus_code V_REAL
  {
    begin
      real = Float(val[1])
    rescue
      raise
    end
    result = real
  }
  | Minus_code V_REAL
  {
    begin
      real = Float(val[1])
    rescue
      raise
    end
    result = - real
  }

real_list_value: real_value Comma_code real_value
  | real_list_value Comma_code real_value
  | real_value Comma_code SYM_LIST_CONTINUE

real_interval_value: SYM_INTERVAL_DELIM real_value SYM_ELLIPSIS real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT real_value SYM_ELLIPSIS real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM real_value SYM_ELLIPSIS SYM_LT real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT real_value SYM_ELLIPSIS SYM_LT real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LT real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LE real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GE real_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM real_value SYM_INTERVAL_DELIM


boolean_value: SYM_TRUE
  { 
    result = true
  }
  | SYM_FALSE
  { 
    result = false
  }

boolean_list_value: boolean_value Comma_code boolean_value
  | boolean_list_value Comma_code boolean_value
  | boolean_value Comma_code SYM_LIST_CONTINUE

character_value: V_CHARACTER

character_list_value: character_value Comma_code character_value
  | character_list_value Comma_code character_value
  | character_value Comma_code SYM_LIST_CONTINUE

date_value: V_ISO8601_EXTENDED_DATE

date_list_value: date_value Comma_code date_value
  | date_list_value Comma_code date_value
  | date_value Comma_code SYM_LIST_CONTINUE

date_interval_value: SYM_INTERVAL_DELIM date_value SYM_ELLIPSIS date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT date_value SYM_ELLIPSIS date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM date_value SYM_ELLIPSIS SYM_LT date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT date_value SYM_ELLIPSIS SYM_LT date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LT date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LE date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GE date_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM date_value SYM_INTERVAL_DELIM

time_value: V_ISO8601_EXTENDED_TIME

time_list_value: time_value Comma_code time_value
  | time_list_value Comma_code time_value
  | time_value Comma_code SYM_LIST_CONTINUE

time_interval_value: SYM_INTERVAL_DELIM time_value SYM_ELLIPSIS time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT time_value SYM_ELLIPSIS time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM time_value SYM_ELLIPSIS SYM_LT time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT time_value SYM_ELLIPSIS SYM_LT time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LT time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LE time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GE time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM time_value SYM_INTERVAL_DELIM

date_time_value: V_ISO8601_EXTENDED_DATE_TIME

date_time_list_value: date_time_value Comma_code date_time_value
  | date_time_list_value Comma_code date_time_value
  | date_time_value Comma_code SYM_LIST_CONTINUE

date_time_interval_value: SYM_INTERVAL_DELIM date_time_value SYM_ELLIPSIS date_time_value  SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_ELLIPSIS date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM date_time_value SYM_ELLIPSIS SYM_LT date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_ELLIPSIS SYM_LT date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LT date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LE date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GE date_time_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM date_time_value SYM_INTERVAL_DELIM

duration_value: V_ISO8601_DURATION
  {
    @@logger.debug("V_ISO8601_DURATION: #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

duration_list_value: duration_value Comma_code duration_value
  | duration_list_value Comma_code duration_value
  | duration_value Comma_code SYM_LIST_CONTINUE

duration_interval_value: SYM_INTERVAL_DELIM duration_value SYM_ELLIPSIS duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT duration_value SYM_ELLIPSIS duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM duration_value SYM_ELLIPSIS SYM_LT duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT duration_value SYM_ELLIPSIS SYM_LT duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LT duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_LE duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GT duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM SYM_GE duration_value SYM_INTERVAL_DELIM
  | SYM_INTERVAL_DELIM duration_value SYM_INTERVAL_DELIM

term_code: V_QUALIFIED_TERM_CODE_REF
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: V_QUALIFIED_TERM_CODE_REF = #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }

term_code_list_value: term_code Comma_code term_code
  | term_code_list_value Comma_code term_code
  | term_code Comma_code SYM_LIST_CONTINUE

uri_value: V_URI
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}: V_URI = #{val[0]} at #{@filename}:#{@lineno}")
    result = val[0]
  }


#---------------------- ASSERTIONS ------------------------

assertions: assertion
  | assertions assertion

assertion: any_identifier ':' boolean_expression
  | boolean_expression
  | any_identifier ':' error

#---------------------- expressions ---------------------

boolean_expression: boolean_leaf
  | boolean_node

boolean_node: SYM_EXISTS absolute_path
#  | absolute_path
  | SYM_EXISTS error
  | relative_path SYM_MATCHES SYM_START_CBLOCK c_primitive SYM_END_CBLOCK
  | relative_path SYM_MATCHES START_REGEXP_BLOCK REGEXP_BODY END_REGEXP_BLOCK # added by akimichi
  | SYM_NOT boolean_leaf
  | arithmetic_expression '=' arithmetic_expression
  | arithmetic_expression SYM_NE arithmetic_expression
  | arithmetic_expression SYM_LT arithmetic_expression
  | arithmetic_expression SYM_GT arithmetic_expression
  | arithmetic_expression SYM_LE arithmetic_expression
  | arithmetic_expression SYM_GE arithmetic_expression
  | boolean_expression SYM_AND boolean_expression
  | boolean_expression SYM_OR boolean_expression
  | boolean_expression SYM_XOR boolean_expression
  | boolean_expression SYM_IMPLIES boolean_expression

boolean_leaf: Left_parenthesis_code boolean_expression Right_parenthesis_code
  | SYM_TRUE
  | SYM_FALSE

arithmetic_expression: arithmetic_leaf
  | arithmetic_node

arithmetic_node: arithmetic_expression '+' arithmetic_leaf
  | arithmetic_expression '-' arithmetic_leaf
  | arithmetic_expression Star_code arithmetic_leaf
  | arithmetic_expression Slash_code arithmetic_leaf
  | arithmetic_expression '^' arithmetic_leaf

arithmetic_leaf:  Left_parenthesis_code arithmetic_expression Right_parenthesis_code
  | integer_value
  | real_value
  | absolute_path


#--------------- THE FOLLOWING SOURCE TAKEN FROM OG_PATH_VALIDATOR.Y -------------
#--------------- except to remove movable_path ----------------------------------------------------


absolute_path: Slash_code
  | Slash_code relative_path
#  | absolute_path Slash_code relative_path



relative_path: path_segment
  | relative_path Slash_code path_segment

path_segment: V_ATTRIBUTE_IDENTIFIER V_LOCAL_TERM_CODE_REF
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}, V_ATTRIBUTE_IDENTIFIER = #{val[0]} at #{@filename}") 
  }
  | V_ATTRIBUTE_IDENTIFIER
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}, V_ATTRIBUTE_IDENTIFIER = #{val[0]} at #{@filename}") 
  }


#-------------------------------- END SOURCE TAKEN FROM OG_PATH_VALIDATOR.Y ----------------------


#---------------- existence, occurrences, cardinality ----------------

c_existence: #-- default to 1..1
    { 
    result = Range.new(1,1)
  }
  | SYM_EXISTENCE SYM_MATCHES SYM_START_CBLOCK existence_spec SYM_END_CBLOCK
  { 
    result = val[3]
  }

existence_spec:  V_INTEGER #-- can only be 0 or 1
  { 
    begin
      integer = Integer(val[0])
    rescue
      raise
    end
    result = integer
  }
  | V_INTEGER SYM_ELLIPSIS V_INTEGER #-- can only be 0..0, 0..1, 1..1
  { 
    begin
      from_integer = Integer(val[0])
      to_integer = Integer(val[2])
    rescue
      raise
    end
    result = Range.new(from_integer,to_integer)
  }

c_cardinality: SYM_CARDINALITY SYM_MATCHES SYM_START_CBLOCK cardinality_spec SYM_END_CBLOCK
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::CARDINALITY.new
  }

cardinality_spec: occurrence_spec
  | occurrence_spec Semicolon_code SYM_ORDERED
  | occurrence_spec Semicolon_code SYM_UNORDERED
  | occurrence_spec Semicolon_code SYM_UNIQUE
  | occurrence_spec Semicolon_code SYM_ORDERED Semicolon_code SYM_UNIQUE
  | occurrence_spec Semicolon_code SYM_UNORDERED Semicolon_code SYM_UNIQUE
  | occurrence_spec Semicolon_code SYM_UNIQUE Semicolon_code SYM_ORDERED
  | occurrence_spec Semicolon_code SYM_UNIQUE Semicolon_code SYM_UNORDERED

cardinality_limit_value: integer_value
  {
    result = val[0]
  }
  | Star_code # '*'
  {
    result = val[0]
  }


c_occurrences:  #-- default to 1..1
  | SYM_OCCURRENCES SYM_MATCHES SYM_START_CBLOCK occurrence_spec SYM_END_CBLOCK
  { 
    result = val[3]
  }
  | SYM_OCCURRENCES error

occurrence_spec: cardinality_limit_value #-- single integer or '*'
  | V_INTEGER SYM_ELLIPSIS cardinality_limit_value

#---------------------- leaf constraint types -----------------------

c_integer_spec: integer_value
  | integer_list_value
  | integer_interval_value

c_integer: c_integer_spec
  | c_integer_spec Semicolon_code integer_value
  | c_integer_spec Semicolon_code error

c_real_spec: real_value
  | real_list_value
  | real_interval_value

c_real: c_real_spec
  | c_real_spec Semicolon_code real_value
  | c_real_spec Semicolon_code error

c_date_constraint: V_ISO8601_DATE_CONSTRAINT_PATTERN
  | date_value
  | date_interval_value

c_date: c_date_constraint
  | c_date_constraint Semicolon_code date_value
  | c_date_constraint Semicolon_code error

c_time_constraint: V_ISO8601_TIME_CONSTRAINT_PATTERN
  | time_value
  | time_interval_value

c_time: c_time_constraint
  | c_time_constraint Semicolon_code time_value
  | c_time_constraint Semicolon_code error

c_date_time_constraint: V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN
  | date_time_value
  | date_time_interval_value

c_date_time: c_date_time_constraint
  | c_date_time_constraint Semicolon_code date_time_value
  | c_date_time_constraint Semicolon_code error

c_duration_constraint: duration_pattern
  | duration_pattern Slash_code duration_interval_value
  | duration_value
  | duration_interval_value

c_duration: c_duration_constraint
  | c_duration_constraint Semicolon_code duration_value
  | c_duration_constraint Semicolon_code error

c_string_spec:  V_STRING #-- single value, generates closed list
  | string_list_value #-- closed list
  | string_list_value Comma_code SYM_LIST_CONTINUE #-- open list
#  | string_list_value ',' SYM_LIST_CONTINUE #-- open list
#  | V_REGEXP #-- regular expression with "//" or "^^" delimiters

c_string: c_string_spec
  | c_string_spec Semicolon_code string_value
  | c_string_spec Semicolon_code error

c_boolean_spec: SYM_TRUE
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN.new(:true_valid => true)
  }
  | SYM_FALSE
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN.new(:true_valid => false)
  }
  | SYM_TRUE Comma_code SYM_FALSE
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN.new(:true_valid => true,:false_valid => false)
  }
  | SYM_FALSE Comma_code SYM_TRUE
  { 
    result = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN.new(:true_valid => false,:false_valid => true)
  }

c_boolean: c_boolean_spec
  { 
    result = val[0]
  }
  | c_boolean_spec Semicolon_code boolean_value
  {
    raise 'Not implemented yet'
  }
  | c_boolean_spec Semicolon_code error
  {
    raise 'Not implemented yet'
  }

c_ordinal: c_ordinal_spec
  | c_ordinal_spec Semicolon_code integer_value
  | c_ordinal_spec Semicolon_code error

c_ordinal_spec: ordinal
  | c_ordinal_spec Comma_code ordinal

ordinal: integer_value SYM_INTERVAL_DELIM V_QUALIFIED_TERM_CODE_REF
  {
    @in_interval = false
    @@logger.debug("#{__FILE__}:#{__LINE__}, #{val[0]}|#{val[2]} at #{@filename}") 
  }

#c_code_phrase: V_TERM_CODE_CONSTRAINT #-- e.g. "[local::at0040, at0041; at0040]"
c_code_phrase: term_code_constraint_section #-- e.g. "[local::at0040, at0041; at0040]"
  {
      result = val[0]
  }
  | V_QUALIFIED_TERM_CODE_REF
  {
      result = val[0]
  }

#                             [[a-zA-Z0-9\(\)\._\-]+::[ \t\n]*          [[a-zA-Z0-9\._\-]*[ \t]*]
term_code_constraint_section: START_TERM_CODE_CONSTRAINT term_code_body END_TERM_CODE_CONSTRAINT
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}, START_TERM_CODE_CONSTRAINT = #{val[0]} at #{@filename}")
    @@logger.debug("#{__FILE__}:#{__LINE__}, term_code_body = #{val[1]}")
    @@logger.debug("#{__FILE__}:#{__LINE__}, END_TERM_CODE_CONSTRAINT = #{val[2]}")
    result = val[1]
  }


term_code_body: # empty
  | TERM_CODE
  | term_code_body TERM_CODE
### term_code_body: TERM_CODE
###   | term_code_body TERM_CODE

# A Constraint_Ref is a proxy for a set of constraints on an object.
constraint_ref: V_LOCAL_TERM_CODE_REF #-- e.g. "ac0003"
  {
      result = val[0]
  }

any_identifier: type_identifier
  {
      result = val[0]
  }
  | V_ATTRIBUTE_IDENTIFIER
  {
    @@logger.debug("#{__FILE__}:#{__LINE__}, V_ATTRIBUTE_IDENTIFIER = #{word} at #{@filename}")
      result = val[0]
  }


#----------------- TAKEN FROM DADL_VALIDATOR.Y -------------------
#-----------------        DO NOT MODIFY        -------------------
#---------------------- BASIC DATA VALUES -----------------------

duration_pattern: V_ISO8601_DURATION_CONSTRAINT_PATTERN
  { 
    result = val[0]
  }



---- header


$:.unshift File.join(File.dirname(__FILE__))
require 'logger'
#require 'lib/adl_parser.rb'
require 'rubygems'
require 'adl_parser.rb'
require 'am.rb'
require 'rm.rb'
$DEBUG = true



---- inner

def assert_at(file,line, message = "")
  unless yield
    raise "Assertion failed !: #{file}, #{line}: #{message}"
  end
end

if $DEBUG
  @@logger = Logger.new('log/parser.log','daily')
  @@logger.level = Logger::INFO
else
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::WARN
end

@@dadl_scanner = OpenEHR::ADL::Scanner::DADL::RootScanner.new
@@cadl_scanner = OpenEHR::ADL::Scanner::CADL::RootScanner.new

###----------/* keywords */ --------------------------------------------- 
@@adl_reserved = {
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

@@dadl_reserved = {
  'true' => :SYM_TRUE, #[Tt][Rr][Uu][Ee] -- -> SYM_TRUE 
  'false' => :SYM_FALSE, # [Ff][Aa][Ll][Ss][Ee] -- -> SYM_FALSE 
  'infinity' => :SYM_INFINITY # [Ii][Nn][Ff][Ii][Nn][Ii][Tt][Yy] -- -> SYM_INFINITY 
}

@@cadl_reserved = {
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


###----------/* Scanner */ ----------------------------------------------- 

def scan
  @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan at #{@filename}:#{@lineno}:")
  until @data.nil?  do
    case @adl_type.last
    when :adl
      @data = scan_adl(@data) do |sym, val|
        yield sym, val
      end
    when :dadl
      @data = scan_dadl(@data) do |sym, val|
        yield sym, val
      end
    when :cadl
      @data = scan_cadl(@data) do |sym, val|
        yield sym, val
      end
    when :regexp
      @data = scan_regexp(@data) do |sym, val|
        yield sym, val
      end
    when :term_constraint
      @@logger.debug("#{__FILE__}:#{__LINE__}: scan: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")
      @data = scan_term_constraint(@data) do |sym, val|
        yield sym, val
      end
    else
      raise
    end
    @data = $' # variable $' receives the string after the match
  end
  yield :EOF, nil
  yield false, '$'
end # of scan

def scan_adl(data)
  @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_adl at #{@filename}:#{@lineno}: data = #{data.inspect}")
  until data.nil?  do
    case @adl_type.last
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
        if @@adl_reserved[word]
          @@logger.debug("#{__FILE__}:#{__LINE__}: scan_adl: @@adl_reserved = #{@@adl_reserved[word]} at #{@filename}:#{@lineno}")
          yield @@adl_reserved[word], @@adl_reserved[word]
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
        if @in_interval
#          @start_block_received = false
          yield :SYM_LT, :SYM_LT
        else
#          @start_block_received = true
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
#        puts "Escaping #{adl_type}"
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
    when :dadl
      data = scan_dadl(data) do |sym, val|
        yield sym, val
      end
    when :cadl
      data = scan_cadl(data) do |sym, val|
        yield sym, val
      end
    when :regexp
      data = scan_regexp(data) do |sym, val|
        yield sym, val
      end
    when :term_constraint
      @@logger.debug("#{__FILE__}:#{__LINE__}: scan_adl: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")

      data = scan_term_constraint(data) do |sym, val|
        yield sym, val
      end
    else
      raise
    end
  end
end # scan_adl


def scan_cadl(data)
  @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_cadl at #{@filename}:#{@lineno}: data = #{data.inspect}")
  until data.nil?  do
    case @adl_type.last
    when :cadl
      case scanned = @@cadl_scanner.parse(data)
      when Yaparc::Result::OK
        if scanned.value[0] == :START_V_C_DOMAIN_TYPE_BLOCK
          @in_c_domain_type = true
          @adl_type.push(:dadl)
          yield scanned.value
        else
          yield scanned.value
        end
        data = scanned.input
      end

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
###       when /\A[A-Z][a-zA-Z0-9_]*[ \n]*\</   # V_C_DOMAIN_TYPE
###         @in_c_domain_type = true
###         @adl_type.push(:dadl)
###         yield :START_V_C_DOMAIN_TYPE_BLOCK, $&
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
#          puts "Escaping #{adl_type}"
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
        if @@cadl_reserved[word.downcase]
          yield @@cadl_reserved[word.downcase], @@cadl_reserved[word.downcase]
        else
          @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: V_ATTRIBUTE_IDENTIFIER = #{word} at #{@filename}:#{@lineno}")
          yield :V_ATTRIBUTE_IDENTIFIER, word #V_ATTRIBUTE_IDENTIFIER /\A[a-z][a-zA-Z0-9_]*/
        end
      when /\A[A-Z][a-zA-Z0-9_]*/
        word = $&.dup
        if @@cadl_reserved[word.downcase]
          yield @@cadl_reserved[word.downcase], @@cadl_reserved[word.downcase]
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
###       when /\AP([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?T([0-9]+[hH])?([0-9]+[mM])?([0-9]+[sS])?|P([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?/   #V_ISO8601_DURATION PnYnMnWnDTnnHnnMnnS
###         yield :V_ISO8601_DURATION, $&
      when /\A\S/ #UTF8CHAR
        yield :UTF8CHAR, $&
      else
        raise
      end
      data = $' # variable $' receives the string after the match
    when :adl
      data = scan_adl(data) do |sym, val|
        yield sym, val
      end
    when :dadl
      data = scan_dadl(data) do |sym, val|
        yield sym, val
      end
    when :regexp
      data = scan_regexp(data) do |sym, val|
        yield sym, val
      end
    when :term_constraint
      @@logger.debug("#{__FILE__}:#{__LINE__}: scan_cadl: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")
      
      data = scan_term_constraint(data) do |sym, val|
        yield sym, val
      end
    else
      raise
    end
  end # of until
end # of scan_cadl

def scan_dadl(data)
  @@logger.debug("#{__FILE__}:#{__LINE__}: Entering scan_dadl at #{@filename}:#{@lineno}: data = #{data.inspect}")
  until data.nil?  do
    case @adl_type.last
    when :dadl
      case scanned = @@dadl_scanner.parse(data)
      when Yaparc::Result::OK
        yield scanned.value
        data = scanned.input
      else
      end

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
#          @in_interval = false
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
###       when /\A\[[a-zA-Z0-9()\._-]+::[a-zA-Z0-9\._-]+\]/   #V_QUALIFIED_TERM_CODE_REF form [ICD10AM(1998)::F23]
###         yield :V_QUALIFIED_TERM_CODE_REF, $&
###       when /\A\[[a-zA-Z0-9][a-zA-Z0-9._\-]*\]/   #V_LOCAL_TERM_CODE_REF
###         yield :V_LOCAL_TERM_CODE_REF, $&
###       when /\A\[[a-zA-Z0-9._\- ]+::[a-zA-Z0-9._\- ]+\]/   #ERR_V_QUALIFIED_TERM_CODE_REF
###         yield :ERR_V_QUALIFIED_TERM_CODE_REF, $&
      when /\A\[/   # [
        yield :Left_bracket_code, :Left_bracket_code
      when /\A\]/   # ]
        yield :Right_bracket_code, :Right_bracket_code
###       when /\A[A-Z][a-zA-Z0-9_-]*/
###         yield :V_TYPE_IDENTIFIER, $&
###       when /\A[A-Z][a-zA-Z0-9_]*<[a-zA-Z0-9,_<>]+>/   #V_GENERIC_TYPE_IDENTIFIER
###         yield :V_GENERIC_TYPE_IDENTIFIER, $&
###       when /\A[a-z][a-zA-Z0-9_]*/
###         word = $&.downcase
###         if @@dadl_reserved[word]
###           yield @@dadl_reserved[word], @@dadl_reserved[word]
###         else
###           yield :V_ATTRIBUTE_IDENTIFIER, $&
###         end
###       when /\Aa[ct][0-9.]+/   #V_LOCAL_CODE
###         yield :V_LOCAL_CODE, $&
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
###       when /\A[0-9]+\.[0-9]+|[0-9]+\.[0-9]+[eE][+-]?[0-9]+ /   #V_REAL
###         yield :V_REAL, $&
        #    when /\A"((?:[^"\\]+|\\.)*)"/ #V_STRING
###       when /\A"([^"]*)"/m #V_STRING
###         yield :V_STRING, $1
      when /\A[a-z]+:\/\/[^<>|\\{}^~"\[\] ]*/ #V_URI
        yield :V_URI, $&
###       when /\AP([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?T([0-9]+[hH])?([0-9]+[mM])?([0-9]+[sS])?|P([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?/   #V_ISO8601_DURATION PnYnMnWnDTnnHnnMnnS
###         yield :V_ISO8601_DURATION, $&
      when /\A\S/ #UTF8CHAR
        yield :UTF8CHAR, $&
      end
      data = $' # variable $' receives the string after the match
    when :adl
      data = scan_adl(data) do |sym, val|
        yield sym, val
      end
    when :cadl
      data = scan_cadl(data) do |sym, val|
        yield sym, val
      end
    when :regexp
#      puts "Entering scan_regexp"
      data = scan_regexp(data) do |sym, val|
        yield sym, val
      end
    when :term_constraint
      @@logger.debug("#{__FILE__}:#{__LINE__}: scan_dadl: Entering scan_term_constraint at #{@filename}:#{@lineno}: data = #{data.inspect}")

      data = scan_term_constraint(data) do |sym, val|
        yield sym, val
      end
    else
      raise
    end
  end
end # of scan_dadl

def scan_regexp(data)
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
      data = scan_adl(data) do |sym, val|
        yield sym, val
      end
    when :dadl
      data = scan_dadl(data) do |sym, val|
        yield sym, val
      end
    when :cadl
      data = scan_cadl(data) do |sym, val|
        yield sym, val
      end
    when :term_constraint
      @@logger.debug("#{__FILE__}:#{__LINE__}: scan_regexp: Entering scan_term_constraint at #{@filename}:#{@lineno}")
      data = scan_term_constraint(data) do |sym, val|
        yield sym, val
      end
    else
      raise
    end
  end
end # of scan_regexp

def scan_term_constraint(data)
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
      data = scan_adl(data) do |sym, val|
        yield sym, val
      end
    when :dadl
      data = scan_dadl(data) do |sym, val|
        yield sym, val
      end
    when :cadl
      data = scan_cadl(data) do |sym, val|
        yield sym, val
      end
    else
      raise
    end
  end
end # of scan_term_constraint


def parse(data, filename, lineno = 1, debug = false)
  @yydebug = true
  @parsestring = data
  @data = data
  @lineno = lineno
  @filename = filename
  @adl_type = [:adl] # {:adl, :cadl, :dadl}
  @in_regexp = false
  @in_interval = false
  @in_c_domain_type = false
  yyparse self, :scan
end

def on_error( t, v, values)
  raise Racc::ParseError, "#{@filename}:#{@lineno}: Inline syntax error on #{v.inspect}"
end







### Local Variables:
### mode:ruby
### mode:font-lock
### comment-column:0
### comment-start: "### "
### comment-end:"" 
### End:




