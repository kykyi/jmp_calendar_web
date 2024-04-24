# frozen_string_literal: true

module Calendar
  module YearOne
    module Une
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
          group = row['Group Letter / Number']
          group_prefix = row[
              "Group Prefix\nCAL=\nCallaghan\nCC=\nCentral Coast\nALL=\nall campuses"
          ]
          mandatory = row["Attendance\n(M =\nmandatory)"]
          time = row['Time']
          domain = row['Domain']
          date = row['Date']
          venue = row['Venue']
          url = row['url']
          name = row['Name of Activity ']

          return unless Calendar::YearOne::Uon::CheckValidEventService.is_valid?(group: group, pbl: pbl,
                                                                                 clin: clin, group_prefix: group_prefix)
          return if !venue && !date && !time
          return unless date > TZInfo::Timezone.get('Australia/Sydney').now

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
            event.url = url if url
          end
        end

        private

        attr_reader :pbl, :clin, :row, :calendar
      end
    end
  end
end
