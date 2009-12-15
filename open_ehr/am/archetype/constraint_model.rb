
module OpenEHR
  module AM
    module Archetype
      module ConstraintModel
        class ArchetypeConstraint
          attr_reader :path
          attr_accessor :parent

          def initialize(args = { })
            self.path = args[:path]
            self.parent = args[:parent]
          end

          def path=(path)
            if path.nil?
              raise ArgumentError, 'path is mandatory'
            end
            @path = path
          end

          def has_path?(path)
            return @path.include?(path)
          end

          def congruent?
            if @path.index(@parent.path) == 0
              return true
            else
              return false
            end
          end

          alias is_congruent? congruent?

          def node_conforms_to?(other)
            if @path.index(other.path) == 0
              return true
            else
              return false
            end
          end
        end

        class Cardinality
          attr_accessor :interval, :is_ordered, :is_unique

          def initialize(args = { })
            @interval = args[:interval]
            @is_ordered = args[:is_ordered]
            @is_unique = args[:is_unique]
          end
        end

        class CObject < ArchetypeConstraint
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

        class CAttribute < ArchetypeConstraint
          attr_accessor :rm_attribute_name, :existence, :children

          def initialize(args = { })
            @rm_attribute_name = args[:rm_attribute_name] if args[:rm_attribute_name]
            @existence = args[:existence] if args[:existence]
            @children = args[:children] ? args[:children] : []
            
          end
        end

        class CDefinedObject < CObject
          attr_accessor :assumed_value
          
          def initialize(args = { })
            @assumed_value = args[:assumed_value] if args[:assumed_value]
            super
          end
        end

        class CPrimitiveObject < CDefinedObject
          attr_accessor :item

          def initialize(args = { })
            @attributes = args[:item] if args[:item]
            super
          end
        end

        class CComplexObject < CDefinedObject
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

        class CDomainType < CDefinedObject
          
        end

        class CReferenceObject < CObject
        end

        class ArchetypeInternalRef < CReferenceObject
          attr_accessor :target_path
        end

        class ArchetypeSlot < CReferenceObject
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

        class ConstantRef < CReferenceObject
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

        class CSingleAttribute < CAttribute
          attr_accessor :alternatives

          def initialize(args = { })
            @alternatives = args[:alternatives] ? args[:alternatives] : []
            super
          end
        end

        class CMultipleAttribute < CAttribute
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
  
