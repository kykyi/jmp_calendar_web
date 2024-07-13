

module Calendars
  module Une
    module YearOne
      class CreateEventService
        def self.call(pbl:, clin:, row:, calendar:)
          new(pbl, clin, row, calendar).call
        end

        def initialize(pbl, clin, row, calendar)
          @pbl = pbl
          @clin = clin
          @row = row
          @calendar = calendar
        end

        def call
          group = row['GROUPS']
          mandatory = row["Attendance\n(M - Mandatory)"]
          time = row['TIME']
          domain = row['TYPE']
          date = row['DATE']
          venue = row['VENUE']
          name = row['SESSION']

          return unless date

          # Sometimes dates are invalid, like Feb 29 on a leap year, just ignore these
          begin
            date = Date.parse(date) unless date.is_a? Date
            return unless date > TZInfo::Timezone.get('Australia/Sydney').now
          rescue Date::Error
            return
          end

          return unless Calendars::Une::YearOne::CheckValidEventService.is_valid?(group: group, pbl: pbl,
                                                                                  clin: clin)

          if time.downcase.include?('self') && time.downcase.include?('directed')
            name = "#{name} (self directed)"
          elsif !mandatory
            name = "#{name} (not mandatory)"
          end

          name = "#{name} - #{domain} (#{group})"

          calendar.event do |event|
            tzid = 'Australia/Sydney'

            event.dtstart = Icalendar::Values::DateTime.new(::TimeService.parse_time(date, time, true),
                                                            'tzid' => tzid)
            event.dtend = Icalendar::Values::DateTime.new(::TimeService.parse_time(date, time, false),
                                                          'tzid' => tzid)

            event.summary = name.strip.squish
            event.location = venue
            # TODO: Add zoom links
            # event.url = url if url
          end
        end

        private

        attr_reader :pbl, :clin, :row, :calendar
      end
    end
  end
end
