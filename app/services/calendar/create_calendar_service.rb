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
            column_headers = spreadsheet.sheet(0).row(2)

            column_headers = column_headers.map { |header| header.gsub(/<[^>]*>/, "") }

            spreadsheet.sheet(0).each_with_index do |row, index|
                next if index == 0 || index == 1
                row = column_headers.zip(row).to_h

                Calendar::YearOne::CreateEventService.call(pbl: pbl, clin: clin, row: row, calendar: calendar) if year == 1
            end

            # To sort the events by datetime, mostly for testing!
            events = calendar.events.sort_by { |e| [e.name.downcase, e.dtstart] }
            calendar = Icalendar::Calendar.new

            events.each do |event|
                calendar.add_event(event)
            end

            calendar
        end

        private

        attr_reader :pbl, :spreadsheet, :year, :clin
    end
end