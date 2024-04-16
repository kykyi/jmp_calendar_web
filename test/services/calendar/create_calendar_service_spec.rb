require 'rails_helper'

RSpec.describe Calendar::CreateCalendarService do
    let(:spreadsheet) { Roo::Excelx.new('test/fixtures/files/test_timetable_year_one.xlsx') }
    describe ".call" do

        before do
            Time.zone = "Australia/Sydney"
            travel_to Time.zone.local(2024, 02, 24, 0, 0, 0)
        end

        shared_examples "create calendar for" do |pbl, clin, year, expected_result_file|
            it "creates the correct events" do
                cal_file = File.open(expected_result_file)
                expected_result = Icalendar::Calendar.parse(cal_file)
                expected_result = expected_result.first.to_ical

                calendar = described_class.call(pbl: pbl, spreadsheet: spreadsheet, year: year, clin: clin)
                calendar.events.each { |event| event.uid = '00000000-0000-0000-0000-000000000000' }

                expect(expected_result).to eq(calendar.to_ical)
            end
        end

        include_examples "create calendar for", "K", "20", 1, 'test/fixtures/files/example_one_year_one.ics'
        include_examples "create calendar for", "E", "5", 1, 'test/fixtures/files/example_two_year_one.ics'
        include_examples "create calendar for", "A", "2", 1, 'test/fixtures/files/example_three_year_one.ics'
    end
end