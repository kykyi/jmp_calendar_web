module Calendar
    class CreateCalendarService
        def self.call(pbl:, spreadsheet:, year:, clin: nil)
            new(pbl, spreadsheet, year, clin).call
        end

        def initialize(pbl, spreadsheet, year, clin)
            @pbl = pbl
            @spreadsheet = spreadsheet
            @year = year
            @clin = clin
        end

        def call
            calendar = Icalendar::Calendar.new
            calendar.timezone do |t|
                t.tzid = "Australia/Sydney"
            end


            if year == 1
                column_headers = spreadsheet.sheet(0).row(2)
            end

            if year == 2
                column_headers = spreadsheet.sheet(0).row(1)
            end

            column_headers = column_headers.map do |header|
                header = header.to_s
                header.gsub(/<[^>]*>/, "")
            end

            spreadsheet.sheet(0).each_with_index do |row, index|
                if year == 1
                    next if index == 0 || index == 1
                end

                if year == 2
                    next if index == 0
                end

                row = column_headers.zip(row).to_h


                Calendar::YearTwo::CreateEventService.call(pbl: pbl, row: row, calendar: calendar) if year == 2
                Calendar::YearOne::CreateEventService.call(pbl: pbl, clin: clin, row: row, calendar: calendar) if year == 1
            end

            calendar
        end

        private

        attr_reader :pbl, :spreadsheet, :year, :clin
    end
end