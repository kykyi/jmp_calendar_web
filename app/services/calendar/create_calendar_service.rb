# frozen_string_literal: true

module Calendar
  class CreateCalendarService
    def self.call(pbl:, spreadsheet:, year:, clin: nil, uni: "UON")
      new(pbl, spreadsheet, year, clin, uni).call
    end

    def initialize(pbl, spreadsheet, year, clin, uni)
      @pbl = pbl
      @spreadsheet = spreadsheet
      @year = year
      @clin = clin
      @uni = uni
    end

    def call
      calendar = Icalendar::Calendar.new
      calendar.timezone do |t|
        t.tzid = 'Australia/Sydney'
      end

      column_headers = spreadsheet.sheet(0).row(2) if year == 1

      column_headers = spreadsheet.sheet(0).row(1) if year == 2

      column_headers = column_headers.map do |header|
        header = header.to_s
        header.gsub(/<[^>]*>/, '')
      end

      spreadsheet.sheet(0).each_with_index do |row, index|
        next if year == 1 && [0, 1].include?(index)

        next if year == 2 && index.zero?

        row = column_headers.zip(row).to_h

        Calendar::YearTwo::CreateEventService.call(pbl: pbl, row: row, calendar: calendar) if year == 2
        if year == 1
          if uni == "UON"
            Calendar::YearOne::Uon::CreateEventService.call(pbl: pbl, clin: clin, row: row,
                                                     calendar: calendar)
          elsif uni == "UNE"
            Calendar::YearOne::Une::CreateEventService.call(pbl: pbl, clin: clin, row: row,
                                                     calendar: calendar)
          end
        end
      end

      calendar
    end

    private

    attr_reader :pbl, :spreadsheet, :year, :clin, :uni
  end
end
