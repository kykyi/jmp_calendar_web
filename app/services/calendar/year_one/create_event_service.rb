module Calendar
    module YearOne
        class CreateEventService
            def self.call(pbl:, clin:, row:,  calendar:)
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
                time = row["Time"]
                domain = row["Domain"]
                date = row["Date"]

                return unless Calendar::YearOne::CheckValidEventService.is_valid?(group: group, pbl: pbl, clin: clin, group_prefix: group_prefix)

                if time.downcase.include?("self") && time.downcase.include?("directed")
                    name = "#{name} (self directed)"
                elif !mandatory
                    name = "#{name} (not mandatory)"
                end

                name = "#{name} - #{domain} (#{group})"

                calendar.event do |event|
                    event.dtstart = Icalendar::Values::Date.new('20050428')
                    event.dtend   = Icalendar::Values::Date.new('20050429')
                    event.summary = name
                end
            end

            private

            attr_reader :pbl, :clin, :row, :calendar

        end
    end
end