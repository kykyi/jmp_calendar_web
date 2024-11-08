

module Calendars
  module Uon
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
          group_prefix = row[
              "Students\nCAL-ALL= Entire Callaghan cohort\nCC-ALL = Entire CCoast cohort"
          ]
          mandatory = row["Attendance\n(M =\nmandatory)"]
          time = row['Time']
          domain = row['Domain']
          date = row['Date']
          venue = row['Venue']
          url = row['url']
          name = row['Session']

          return unless Calendars::Uon::YearOne::CheckValidEventService.is_valid?(pbl: pbl,
                                                                                  clin: clin, group_prefix: group_prefix)
          return if !venue && !date && !time
          return unless date > TZInfo::Timezone.get('Australia/Sydney').now

          if time.downcase.include?('self') && time.downcase.include?('directed')
            name = "#{name} (self directed)"
          elsif !mandatory
            name = "#{name} (not mandatory)"
          end

          name = "#{name} - #{domain} (#{group_prefix})"

          calendar.event do |event|
            tzid = 'Australia/Sydney'
            event.dtstart = Icalendar::Values::DateTime.new(::TimeService.parse_time(date, time, true),
                                                            'tzid' => tzid)
            event.dtend = Icalendar::Values::DateTime.new(::TimeService.parse_time(date, time, false),
                                                          'tzid' => tzid)

            event.summary = name.strip.squish
            event.location = venue
            # TODO: Add zoom links
            event.url = url if url
          end
        rescue StandardError => e
          Sentry.capture_exception(e)
        end

        private

        attr_reader :pbl, :clin, :row, :calendar
      end
    end
  end
end
