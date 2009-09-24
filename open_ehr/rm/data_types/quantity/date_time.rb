# This module is implementation of the UML:
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109696321450_28117_5362Report.html
# Ticket refs #49
require 'assumed_library_types'
require 'date'

module OpenEhr
  module RM
    module DataTypes
      module Quantity
        module DateTime
          class DvTemporal < OpenEhr::RM::DataTypes::Quantity::DvAbsoluteQuantity
            include Comparable
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

            def <=>(other)
              self.magnitude <=> other.magnitude
            end
          end

          class DvDate < DvTemporal
            include OpenEhr::AssumedLibraryTypes::ISO8601_DATE_MODULE

            DAYS_IN_MONTH = [0,31,28,31,30,31,30,31,31,30,31,30,31]

            def initialize(value, magnitude_status=nil, accuracy=nil,
                           normal_range=nil, normal_status=nil,
                           other_reference_range=nil)
              super(value, magnitude_status, accuracy, normal_range,
                    normal_status, other_reference_range)
            end

            def value=(value)
              super(value)
              iso8601_date = AssumedLibraryTypes::ISO8601_DATE.new(value)
              @year = iso8601_date.year
              @month = iso8601_date.month
              @day = iso8601_date.day
            end

            undef magnitude=

            def magnitude
              return Date.new(@year, @month, @day)-Date.new(0000,1,1)
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
              return DvDuration.new(
                   'P' + year.to_s + 'Y' + month.to_s + 'M' + 
                         week.to_s + 'W' + day.to_s + 'D')
            end
          end
          
          class DvTime < DvTemporal
            include OpenEhr::AssumedLibraryTypes::ISO8601_TIME_MODULE
            def initialize(value, magnitude_status=nil, accuracy=nil,
                           normal_range=nil, normal_status=nil,
                           other_reference_range=nil)
              super(value, magnitude_status, accuracy, normal_range,
                    normal_status, other_reference_range)
            end

            def value=(value)
              super(value)
              iso8601_time = AssumedLibraryTypes::ISO8601_TIME.new(value)
              @hour = iso8601_time.hour
              @minute = iso8601_time.minute
              @second = iso8601_time.second
              @fractional_second = iso8601_time.fractional_second
            end

            def magnitude
              return @hour * 60 * 60 + @minute * 60 + @second + @fractional_second
            end

            def diff(other)
              diff = (other.magnitude - self.magnitude).abs
              hour = (diff / 60 / 60).to_i
              minute = ((diff - hour*60*60)/60).to_i
              second = (diff - hour * 60 *60 - minute * 60).to_i
              fractional_second = ((diff - diff.to_i)*1000000.0).to_i/1000000.0
              return DvDuration.new('P0Y0M0W0DT' + hour.to_s + 'H' +
                        minute.to_s + 'M' +
                        second.to_s + fractional_second.to_s[1..-1] + 'S')
            end
          end

          class DvDateTime < DvTemporal
            include OpenEhr::AssumedLibraryTypes::ISO8601_DATE_TIME_MODULE
            attr_reader :value

            def initialize(value, magnitude_status=nil, accuracy=nil,
                           normal_range=nil, normal_status=nil,
                           other_reference_range=nil)
              super(value, magnitude_status, accuracy, normal_range,
                    normal_status, other_reference_range)
            end

            def value=(value)              
              super(value)
              iso8601date_time = AssumedLibraryTypes::ISO8601_DATE_TIME.new(value)
              self.year = iso8601date_time.year
              self.month = iso8601date_time.month
              self.day = iso8601date_time.day
              self.minute = iso8601date_time.minute
              self.second = iso8601date_time.second
              self.hour = iso8601date_time.hour
              self.fractional_second = iso8601date_time.fractional_second
              self.timezone = iso8601date_time.timezone
            end

            def magnitude
              seconds = DateTime.new(@year,@month,@day,@hour,@minute,@second) - 
                DateTime.new(0000,1,1,0,0,0)
              if @fractional_second.nil?
                return seconds
              else
                return seconds + @fractional_second
              end
            end

            undef magnitude=

            def diff(other)
              if self.magnitude >= other.magnitude
                past, future = other, self
              else
                past, future = self, other
              end
              past_date, past_time = split_date_time(past)
              future_date, future_time = split_date_time(future)
              time_diff = future_time.magnitude - past_time.magnitude
              if future_time.magnitude < past_time.magnitude
                future_date.day = future_date.day - 1
                time_diff += 24 * 60 * 60
              end
              date_duration = past_date.diff(future_date)
              hour = (time_diff / 60 / 60).to_i
              minute = ((time_diff - hour*60*60)/60).to_i
              second = (time_diff - hour * 60 *60 - minute * 60).to_i
              fractional_second = ((time_diff - time_diff.to_i)*1000000.0).to_i/1000000.0

              return DvDuration.new(date_duration.value + 'T' +
                        hour.to_s + 'H' +
                        minute.to_s + 'M' +
                        second.to_s + fractional_second.to_s[1..-1] + 'S')
                                   
            end

            private

            def split_date_time(date_time)
              /^(.*)T(.*)$/ =~ date_time.as_string
              return DvDate.new($1), DvTime.new($2)
            end
          end

          class DvDuration < DvAmount
            include AssumedLibraryTypes::ISO8601_DURATION_MODULE
            attr_reader :value
            
            def initialize(value, magnitude_status=nil, accuracy=nil,
                         accuracy_percent=nil, normal_range=nil,
                         normal_status = nil, other_reference_ranges=nil)
              self.value = value
            end

            def value=(value)
              raise ArgumentError, 'value must be not nil' if value.nil?
              @value = value
              iso8601_duration = AssumedLibraryTypes::ISO8601_DURATION.new(value)
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
        end # of DateTime
      end # of Quantity
    end # of Data_Types
  end # of RM
end # of OpenEHR
