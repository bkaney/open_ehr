# This module is implementation of the UML:
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109696321450_28117_5362Report.html
# Ticket refs #49
require 'assumed_library_types'

module OpenEHR
  module RM
    module Data_Types
      module Quantity
        module Date_Time
          class DV_Temporal < OpenEHR::RM::Data_Types::Quantity::DV_Absolute_Quantity
            attr_reader :value

            def initialize(value, magnitude_status=nil, accuracy=nil,
                         normal_range=nil, normal_status=nil,
                         other_reference_ranges=nil)
              self.value = value
              self.magnitude_status = magnitude_status
              self.accuracy = accuracy
              self.normal_range = normal_range
              self.normal_status = normal_status
              self.other_reference_ranges = other_reference_ranges
            end

            def value=(value)
              if value.nil? or value.empty?
                raise ArgumentError, 'invalid value'
              end
              @value = value
            end
          end

          class DV_Date < DV_Temporal
            include OpenEHR::Assumed_Library_Types::ISO8601_DATE_MODULE

            DAYS_IN_MONTH = [0,31,28,31,30,31,30,31,31,30,31,30,31]

            def initialize(value, magnitude_status=nil, accuracy=nil,
                           normal_range=nil, normal_status=nil,
                           other_reference_range=nil)
              super(value, magnitude_status, accuracy, normal_range,
                    normal_status, other_reference_range)
            end

            def value=(value)
              super(value)
              iso8601_date = Assumed_Library_Types::ISO8601_DATE.new(value)
              @year = iso8601_date.year
              @month = iso8601_date.month
              @day = iso8601_date.day
            end

            undef magnitude=

            def magnitude
              return Date.new(@year, @month, @day)-Date.new(1601,1,1)
            end

            def diff(other)
              if self.magnitude > other.magnitude
                past, future = other, self
              else
                past, future = self, other
              end
              year, month, day = 0, 0, 0
              if (future.day >= past.day)
                day = future.day - past.day
              else
                month -= 1
                previous_month = future.month - 1
                if previous_month <= 0
                  previous_month = 12
                end
                day = DAYS_IN_MONTH[previous_month] + future.day - past.day
                if leapyear?(future.year) && (previous_month == 2)
                  day += 1
                end
              end
              week = day / 7
              if (future.month >= past.month)
                month += future.month - past.month
              else
                year -= 1
                month += future.month + 12 - past.month
              end
              year += future.year - past.year
              return DV_Duration.new(
                   'P' + year.to_s + 'Y' + month.to_s + 'M' + 
                         week.to_s + 'W' + day.to_s + 'D')
            end
          end
          
          class DV_Time
            def initialize
            end
          end

          class DV_Date_Time
            def initialize
            end
          end

          class DV_Duration < DV_Amount
            include Assumed_Library_Types::ISO8601_DURATION_MODULE
            attr_reader :value
            
            def initialize(value, magnitude_status=nil, accuracy=nil,
                         accuracy_percent=nil, normal_range=nil,
                         normal_status = nil, other_reference_ranges=nil)
              self.value = value
            end

            def value=(value)
              raise ArgumentError, 'value must be not nil' if value.nil?
              @value = value
              iso8601_duration = Assumed_Library_Types::ISO8601_DURATION.new(value)
              self.years = iso8601_duration.years
              self.months = iso8601_duration.months
              self.weeks = iso8601_duration.weeks
              self.days = iso8601_duration.days
              self.hours = iso8601_duration.hours
              self.minutes = iso8601_duration.minutes
              self.seconds = iso8601_duration.seconds
              self.fractional_second = iso8601_duration.fractional_second
            end

            def magnitude
              return ((((@year + @month/MONTH_IN_YEAR)*NOMINAL_DAYS_IN_MONTH) +
                @week * DAYS_IN_WEEK + @days) * HOURS_IN_DAY * MINUTES_IN_HOUR*
                SECONDS_IN_MINUTE) + @second + @fractional_second
            end
            
            undef magnitude=

          end
        end # of Date_Time
      end # of Quantity
    end # of Data_Types
  end # of RM
end # of OpenEHR
