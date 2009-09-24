require 'test/unit'
require 'am.rb'
require 'rm.rb'

class ArchetypeModelTest < Test::Unit::TestCase
  def setup
    @archetype = OpenEhr::AM::Archetype::ARCHETYPE.new
    @validity_kind = OpenEhr::AM::Archetype::VALIDITY_KIND.new

    @archetype_description = OpenEhr::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION.new
    @archetype_description_item = OpenEhr::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION_ITEM.new
  end
  
  def test_init
    assert_instance_of OpenEhr::AM::Archetype::ARCHETYPE, @archetype
    assert_instance_of OpenEhr::AM::Archetype::VALIDITY_KIND, @validity_kind
    assert_instance_of OpenEhr::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION, @archetype_description
    assert_instance_of OpenEhr::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION_ITEM, @archetype_description_item
    assert_instance_of OpenEhr::AM::Archetype::ARCHETYPE, @archetype
  end

  def test_create
    archetype_instance = OpenEhr::AM::Archetype::ARCHETYPE.create() do |archetype|
      archetype.adl_version = '1.4'
    end

    assert_instance_of OpenEhr::AM::Archetype::ARCHETYPE, archetype_instance
  end
end

class ArchetypeModelConstraintTest < Test::Unit::TestCase
  def setup
    @archetype_constraint = OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_CONSTRAINT.new
    @cardinality = OpenEhr::AM::Archetype::Constraint_Model::CARDINALITY.new
    
    @archetype_constraint = OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_CONSTRAINT.new
    @c_object = OpenEhr::AM::Archetype::Constraint_Model::C_OBJECT.new
    @c_defined_object = OpenEhr::AM::Archetype::Constraint_Model::C_DEFINED_OBJECT.new
    @c_attribute = OpenEhr::AM::Archetype::Constraint_Model::C_ATTRIBUTE.new
    @c_single_attribute = OpenEhr::AM::Archetype::Constraint_Model::C_SINGLE_ATTRIBUTE.new
    @c_multiple_attribute = OpenEhr::AM::Archetype::Constraint_Model::C_MULTIPLE_ATTRIBUTE.new(:rm_attribute_name => 'attribute_name', :cardinality => @cardinality)
    @c_primitive_object = OpenEhr::AM::Archetype::Constraint_Model::C_PRIMITIVE_OBJECT.new
    @c_reference_object =  OpenEhr::AM::Archetype::Constraint_Model::C_REFERENCE_OBJECT.new
    @archetype_internal_ref =  OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_INTERNAL_REF.new
    @archetype_slot = OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_SLOT.new
    @constraint_ref = OpenEhr::AM::Archetype::Constraint_Model::CONSTRAINT_REF.new
    @c_domain_type = OpenEhr::AM::Archetype::Constraint_Model::C_DOMAIN_TYPE.new
    @c_complex_object = OpenEhr::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT.new(:attributes => [@c_single_attribute])
  end

  def test_init
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_CONSTRAINT, @archetype_constraint
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_OBJECT, @c_object
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_DEFINED_OBJECT, @c_defined_object
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_ATTRIBUTE, @c_attribute
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_SINGLE_ATTRIBUTE, @c_single_attribute
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_MULTIPLE_ATTRIBUTE, @c_multiple_attribute
    assert_equal 'attribute_name', @c_multiple_attribute.rm_attribute_name
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::CARDINALITY, @c_multiple_attribute.cardinality
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_PRIMITIVE_OBJECT, @c_primitive_object
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_REFERENCE_OBJECT, @c_reference_object
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_INTERNAL_REF, @archetype_internal_ref
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_SLOT, @archetype_slot
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::CONSTRAINT_REF, @constraint_ref
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_DOMAIN_TYPE, @c_domain_type
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT, @c_complex_object
    assert_instance_of Array, @c_complex_object.attributes
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::ARCHETYPE_CONSTRAINT, @archetype_constraint
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::CARDINALITY, @cardinality
  end

  def test_create
    c_complex_object = OpenEhr::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT.create(:node_id => 'test_node',
                                                                                         :attributes => [1,2],
                                                                                         :assumed_value => Array
                                                                                         )
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT, c_complex_object
    assert_equal 'test_node', c_complex_object.node_id
  end
end

class ArchetypeModelPrimitiveTest < Test::Unit::TestCase
  def setup
    #@c_primitive = OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_PRIMITIVE.new
    @c_boolean = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN.new(:true_valid => true,
                                                                                    :false_valid => true,
                                                                                    :assumed_value => true)
    @c_string = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_STRING.new
    @c_integer = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_INTEGER.new
    @c_real = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_REAL.new
    @c_time = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_TIME.new
    @c_date = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_DATE.new
    @c_date_time = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_DATE_TIME.new
    @c_duration = OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_DURATION.new
  end

  def test_init
    #assert_instance_of OpenEHR::AM::Archetype::Constraint_Model::Primitive::C_PRIMITIVE, @c_primitive
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN, @c_boolean
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_STRING, @c_string
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_INTEGER, @c_integer
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_REAL, @c_real
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_TIME, @c_time
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_DATE, @c_date
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_DATE_TIME, @c_date_time
    assert_instance_of OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_DURATION, @c_duration
  end

  def test_primitive
    assert @c_boolean.true_valid
    assert @c_boolean.false_valid
    assert @c_boolean.assumed_value
    assert @c_boolean.has_assumed_value?
    assert @c_boolean.default_value
    assert @c_boolean.default_value(true)
    assert_raise(ArgumentError) do
      @c_boolean.true_valid = false
      @c_boolean.false_valid = false
    end
    assert_raise(ArgumentError) do 
      OpenEhr::AM::Archetype::Constraint_Model::Primitive::C_BOOLEAN.new(:true_valid =>false,
                                                                         :false_valid => false,
                                                                         :assumed_value => false)
    end
  end
  
end

class ArchetypeModelOntologyTest < Test::Unit::TestCase
  def setup
    @archetype_ontology = OpenEhr::AM::Archetype::Ontology::ARCHETYPE_ONTOLOGY.new
    @archetype_term = OpenEhr::AM::Archetype::Ontology::ARCHETYPE_TERM.new(:code => '', :items => '')
  end

  def test_init
    assert_instance_of OpenEhr::AM::Archetype::Ontology::ARCHETYPE_ONTOLOGY, @archetype_ontology
    assert_instance_of OpenEhr::AM::Archetype::Ontology::ARCHETYPE_TERM, @archetype_term
  end
end
    
class ArchetypeModelAssertionTest < Test::Unit::TestCase
  def setup
    @assertion = OpenEhr::AM::Archetype::Assertion::ASSERTION.new
    @assertion_variable = OpenEhr::AM::Archetype::Assertion::ASSERTION_VARIABLE.new
    @operator_kind = OpenEhr::AM::Archetype::Assertion::OPERATOR_KIND.new
    @expr_item = OpenEhr::AM::Archetype::Assertion::EXPR_ITEM.new
    @expr_leaf = OpenEhr::AM::Archetype::Assertion::EXPR_LEAF.new
    @expr_operator = OpenEhr::AM::Archetype::Assertion::EXPR_OPERATOR.new
    @expr_unary_operator = OpenEhr::AM::Archetype::Assertion::EXPR_UNARY_OPERATOR.new
    @expr_binary_operator = OpenEhr::AM::Archetype::Assertion::EXPR_BINARY_OPERATOR.new
  end

  def test_init
    assert_instance_of OpenEhr::AM::Archetype::Assertion::ASSERTION, @assertion
    assert_instance_of OpenEhr::AM::Archetype::Assertion::ASSERTION_VARIABLE, @assertion_variable
    assert_instance_of OpenEhr::AM::Archetype::Assertion::OPERATOR_KIND, @operator_kind
    assert_instance_of OpenEhr::AM::Archetype::Assertion::EXPR_ITEM, @expr_item
    assert_instance_of OpenEhr::AM::Archetype::Assertion::EXPR_LEAF, @expr_leaf
    assert_instance_of OpenEhr::AM::Archetype::Assertion::EXPR_OPERATOR, @expr_operator
    assert_instance_of OpenEhr::AM::Archetype::Assertion::EXPR_UNARY_OPERATOR, @expr_unary_operator
    assert_instance_of OpenEhr::AM::Archetype::Assertion::EXPR_BINARY_OPERATOR, @expr_binary_operator
  end
end

class ArchetypeModelProfileTest < Test::Unit::TestCase
  def setup
    @c_dv_state = OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::C_DV_STATE.new
    @state_machine = OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::STATE_MACHINE.new
    @state = OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::STATE.new
    @terminal_state = OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::TERMINAL_STATE.new
    @non_terminal_state = OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::NON_TERMINAL_STATE.new
    @transition = OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::TRANSITION.new

    @c_code_phase = OpenEhr::AM::OpenEHR_Profile::DataTypes::Text::C_CODE_PHASE.new

    @c_dv_quantity = OpenEhr::AM::OpenEHR_Profile::DataTypes::Quantity::C_DV_QUANTITY.new
    @c_dv_ordinal = OpenEhr::AM::OpenEHR_Profile::DataTypes::Quantity::C_DV_ORDINAL.new
    @c_quantity_item = OpenEhr::AM::OpenEHR_Profile::DataTypes::Quantity::C_QUANTITY_ITEM.new
  end

  def test_init
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::C_DV_STATE, @c_dv_state
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::STATE_MACHINE, @state_machine
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::STATE, @state
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::TERMINAL_STATE, @terminal_state
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::NON_TERMINAL_STATE, @non_terminal_state
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Basic::TRANSITION, @transition
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Text::C_CODE_PHASE, @c_code_phase
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Quantity::C_DV_QUANTITY, @c_dv_quantity
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Quantity::C_DV_ORDINAL, @c_dv_ordinal
    assert_instance_of OpenEhr::AM::OpenEHR_Profile::DataTypes::Quantity::C_QUANTITY_ITEM, @c_quantity_item
  end
end
