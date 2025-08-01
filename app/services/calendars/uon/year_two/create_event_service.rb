

module Calendars
  module Uon
    module YearTwo
      class CreateEventService
        def self.call(pbl:, row:, calendar:)
          new(pbl, row, calendar).call
        end

        def initialize(pbl, row, calendar)
          @pbl = pbl
          @row = row
          @calendar = calendar
        end

        def call
          campus = row['Campus']
          group = row['Group']
          venue = row["Primary \nVenue/\nZoom Link"]


          mandatory = row['Attendance'] == 'MAND' || row['Attendance'] == "MAND " || row['Attendance '] == "MAND" # the space
          time = row['Time']
          date = row['Date']
          domain = row['Domain']
          typex = row["Type"]
          name = row['Session']

          return unless Calendars::Uon::YearTwo::CheckValidEventService.is_valid?(campus: campus, pbl: pbl,
                                                                                  group: group)
          return if !venue && !date && !time
          return unless date > TZInfo::Timezone.get('Australia/Sydney').now

          if time.downcase.include?('self') && time.downcase.include?('directed')
            name = "#{name} (self directed)"
          elsif mandatory
            name = "#{name} (mandatory)"
          end

          name = "#{name} #{typex} - #{domain} (#{campus})"

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
        rescue StandardError => e
          Sentry.capture_exception(e)
        end

        private

        attr_reader :pbl, :row, :calendar
      end
    end
  end
end
