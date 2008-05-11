module OpenEHR
  module AM
    module Archetype
      class VALIDITY_KIND
        attr_accessor :value
        MANDATORY = 1001
        OPTIONAL = 1002
        DISALLOWED = 1003
        
        def initialize(arg)
          @value = arg
        end
        
        def valid_validity
          
        end
      end
    end # of Archetype
  end # of AM
end # of OpenEHR
