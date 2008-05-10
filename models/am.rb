$:.unshift File.join(File.dirname(__FILE__))
#! /usr/bin/env ruby
# component: openEHR Ruby reference implementation
# description: This file includes Archetype 
#      class that contains Archetype values.
#      Main concept is based on Java ref impl.
#      We should make refactoring to suit for Ruby way.
# keywords: archetype
# author: Akimichi TATSUKAWA, Shinji KOBAYASHI
# support: openEHR.jp
# license: openEHR open source license
#

require 'rm/common/resource.rb'
#require 'rm/support/terminology/openehr_code_set_identifier.rb'
module OpenEHR
  module AM
    module Archetype
      autoload :ARCHETYPE, "am/archetype/archetype.rb"
      autoload :Constraint_Model, "am/archetype/constraint_model/archetype_constraint.rb"
      autoload :Ontology, "am/archetype/ontology.rb"
      
      module Archetype_Description
        autoload :ARCHETYPE_DESCRIPTION, "am/archetype/archetype_description/archetype_description.rb"
      end

      module Constraint_Model
        autoload :ARCHETYPE_CONSTRAINT, "am/archetype/constraint_model/archetype_constraint.rb"
        autoload :ARCHETYPE_SLOT, "am/archetype/constraint_model/archetype_constraint.rb"
        autoload :Primitive, "am/archetype/constraint_model/primitive.rb"
      end #end of ConstraintModel

      module Assertion
        autoload :ASSERTION, "am/archetype/constraint_model/assertion.rb"
      end

    end # of Archetype

    module OpenEHR_Profile
      module Data_Types
        module Basic
          autoload :C_DV_STATE, "am/openehr_profile/data_types/basic.rb"
        end

        module Text
          autoload :C_CODE_PHASE, "am/openehr_profile/data_types/text.rb"
        end

        module Quantity
          autoload :C_DV_QUANTITY, "am/openehr_profile/data_types/quantity.rb"
          autoload :C_DV_ORDINAL, "am/openehr_profile/data_types/quantity.rb"
          autoload :C_QUANTITY_ITEM, "am/openehr_profile/data_types/quantity.rb"
        end
      end
    end
  end # of AM
end # of OpenEHR
