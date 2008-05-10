
module OpenEHR
  module AM
    module Archetype
      module Constraint_Model
        class ARCHETYPE_CONSTRAINT
          
        end

        class CARDINALITY
          attr_accessor :interval, :is_ordered, :is_unique

          def initialize(args = { })
            @interval = args[:interval]
            @is_ordered = args[:is_ordered]
            @is_unique = args[:is_unique]
          end
        end

        class C_OBJECT < ARCHETYPE_CONSTRAINT
          attr_accessor :node_id, :occurrences, :rm_type_name

          def initialize(args = { })
            @node_id = args[:node_id] if args[:node_id]
            @occurrences = args[:occurrences] if args[:occurrences]
            @rm_type_name = args[:rm_type_name] if args[:rm_type_name]
          end

          def self.create(args = { }, &block)
            c_object = new(args)
            if block_given?
              yield c_object
            end
            return c_object
          end
        end

        class C_ATTRIBUTE < ARCHETYPE_CONSTRAINT
          attr_accessor :rm_attribute_name, :existence, :children

          def initialize(args = { })
            @rm_attribute_name = args[:rm_attribute_name] if args[:rm_attribute_name]
            @existence = args[:existence] if args[:existence]
            @children = args[:children] ? args[:children] : []
            
          end
        end

        class C_DEFINED_OBJECT < C_OBJECT
          attr_accessor :assumed_value
          
          def initialize(args = { })
            @assumed_value = args[:assumed_value] if args[:assumed_value]
            super
          end
        end

        class C_PRIMITIVE_OBJECT < C_DEFINED_OBJECT
          attr_accessor :item

          def initialize(args = { })
            @attributes = args[:item] if args[:item]
            super
          end
        end

        class C_COMPLEX_OBJECT < C_DEFINED_OBJECT
          attr_accessor :attributes, :attributes_valid

          def initialize(args = { })
            @attributes = args[:attributes] ? args[:attributes] : []
            super
          end

          def self.create(args = { }, &block)
            c_complex_object = new(args)
            if block_given?
              yield c_complex_object
            end
            return c_complex_object
          end
        end

        class C_DOMAIN_TYPE < C_DEFINED_OBJECT
          
        end

        class C_REFERENCE_OBJECT < C_OBJECT
        end

        class ARCHETYPE_INTERNAL_REF < C_REFERENCE_OBJECT
          attr_accessor :target_path
        end

        class ARCHETYPE_SLOT < C_REFERENCE_OBJECT
          attr_accessor :includes, :excludes

          def self.create(args = { }, &block)
            archetype_slot = new(args)
            archetype_slot.includes = args[:includes]
            archetype_slot.excludes = args[:excludes]
            if block_given?
              yield archetype_slot
            end
            return archetype_slot
          end
        end

        class CONSTRAINT_REF < C_REFERENCE_OBJECT
          attr_accessor :reference

          def self.create(args = { }, &block)
            constraint_ref = new(args)
            constraint_ref.reference = args[:reference]
            if block_given?
              yield constraint_ref
            end
            return constraint_ref
          end
        end

        class C_SINGLE_ATTRIBUTE < C_ATTRIBUTE
          attr_accessor :alternatives

          def initialize(args = { })
            @alternatives = args[:alternatives] ? args[:alternatives] : []
            super
          end
        end

        class C_MULTIPLE_ATTRIBUTE < C_ATTRIBUTE
          attr_accessor :members, :cardinality
          
          def initialize(args = { })
            @members = args[:members] ? args[:members] : []
            @cardinality = args[:cardinality] if args[:cardinality]
            super
          end
        end
      end
    end
  end
end
  
