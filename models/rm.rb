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
  module RM
    autoload :Demographic, "rm/demographic.rb"

    module Common
      autoload :Resource, "rm/common/resource.rb"
    end

    module Support
      autoload :Definition, "rm/support/definition.rb"

      module Identification
        autoload :OBJECT_ID, "rm/support/identification.rb"
      end

      module Terminology
        autoload :Terminology, "rm/support/terminology.rb"
      end
    end

    module Data_Types
      autoload :Basic, "rm/data_types/basic.rb"
      autoload :Text, "rm/data_types/text.rb"
      autoload :URI, "rm/data_types/uri.rb"
      autoload :Quantity, "rm/data_types/quantity.rb"
    end
  end
end
