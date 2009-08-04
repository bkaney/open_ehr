$:.unshift File.join(File.dirname(__FILE__))
# component: openEHR Ruby reference implementation
# description: This file contains rm.packages.domain classes
# keywords: archetype
# author: Shinji KOBAYASHI, Akimichi TATSUKAWA
# support: openEHR.jp
# license: openEHR open source license
#

# OpenEHR::RM
module OpenEHR

  autoload :Assumed_Library_Types, "assumed_library_types.rb"

  module RM
    autoload :Demographic, "rm/demographic.rb"
    autoload :Security, "rm/security.rb"

    module Common
      autoload :Resource, "rm/common/resource.rb"
      autoload :Archetyped, "rm/common/archetyped.rb"
      autoload :Generic, "rm/common/generic.rb"
      autoload :Directory, "rm/common/directory.rb"
      autoload :Change_Control, "rm/common/change_control.rb"
    end

    module Support
      autoload :Definition, "rm/support/definition.rb"
      autoload :Identification, "rm/support/identification.rb"
      autoload :Terminology, "rm/support/terminology.rb"
    end

    module Data_Types
      autoload :Basic, "rm/data_types/basic.rb"
      autoload :Text, "rm/data_types/text.rb"
      autoload :URI, "rm/data_types/uri.rb"
      autoload :Quantity, "rm/data_types/quantity.rb"
      autoload :Encapsulated, "rm/data_types/encapsulated.rb"
      autoload :Time_Specification, 'rm/data_types/time_specification.rb'
    end

    module Data_Structures
      autoload :Data_Structure, "rm/data_structure.rb"
      autoload :History, 'rm/data_structures/history.rb'
      autoload :Item_Structure, 'rm/data_structures/item_structure.rb'
    end

    module Security
      autoload :Security, 'rm/security.rb'
    end
  end

end
