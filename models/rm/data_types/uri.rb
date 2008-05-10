require 'uri'
#require 'uri/generic'
module URI
  class EHR < ::URI::Generic
    COMPONENT = [
      :scheme, :path, :fragment, :query
    ].freeze
    def self.build(args)
      tmp = Util::make_components_hash(self, args)
      super(tmp)
    end
    def initialize(*arg)
      super(*arg)
    end
    def self.use_registry
      true
    end
  end
  @@schemes['EHR'] = EHR
end
module OpenEHR
  module RM
    module Data_Types
      module URI
        class DV_URI < OpenEHR::RM::Data_Types::Basic::Data_Value
          def initialize(value)
            raise ArgumentError, "value is empty" if value.nil?
            parse(value)
          end
          def fragment_id
            @value.fragment
          end
          def path
            @value.path
          end
          def query
            @value.query
          end
          def scheme
            @value.scheme
          end
          def value=(value)
            parse(value)
          end
          def value
            @value.to_s
          end
          private
          def parse(value)
            @value = ::URI.parse(value)
          end
        end
        class DV_EHR_URI < DV_URI
          def initialize(value)
            check_value(value)
            super(value)
          end
          def value=(value)
            check_value(value)
            parse(value)
          end
          private
          def check_value(value)
            if !(value =~ /^ehr/i)
              raise ArgumentError, "scheme must be ehr"
            end
          end
        end # of DV_EHR_URI
      end # of URI
    end # of Data_Type
  end # of RM
end # of OpenEHR
