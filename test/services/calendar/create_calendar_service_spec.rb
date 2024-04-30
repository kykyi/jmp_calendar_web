

require 'rails_helper'

RSpec.describe Calendar::CreateCalendarService do
  describe '.call' do

    context "une" do
      context 'year one' do
        let(:spreadsheet) { Roo::Excelx.new('test/fixtures/files/test_timetable_year_one_une.xlsx') }

        before do
          Time.zone = 'Australia/Sydney'
          travel_to Time.zone.local(2024, 0o2, 24, 0, 0, 0)
        end

        shared_examples 'create calendar for' do |pbl, clin, year, expected_result_file|
          it 'creates the correct events' do
            cal_file = File.open(expected_result_file)
            expected_result = Icalendar::Calendar.parse(cal_file)
            expected_result = expected_result.first.to_ical

            calendar = described_class.call(pbl: pbl, spreadsheet: spreadsheet, year: year, clin: clin, uni: "une")
            calendar.events.each { |event| event.uid = '00000000-0000-0000-0000-000000000000' }

            expect(expected_result).to eq(calendar.to_ical)
          end
        end

        include_examples 'create calendar for', 'B', '16', 1, 'test/fixtures/files/example_one_year_one_une.ics'
        include_examples 'create calendar for', 'E', '5', 1, 'test/fixtures/files/example_two_year_one_une.ics'
        include_examples 'create calendar for', 'A', '2', 1, 'test/fixtures/files/example_three_year_one_une.ics'
      end
    end

    context "uon" do
      context 'year one' do
        let(:spreadsheet) { Roo::Excelx.new('test/fixtures/files/test_timetable_year_one.xlsx') }

        before do
          Time.zone = 'Australia/Sydney'
          travel_to Time.zone.local(2024, 0o2, 24, 0, 0, 0)
        end

        shared_examples 'create calendar for' do |pbl, clin, year, expected_result_file|
          it 'creates the correct events' do
            cal_file = File.open(expected_result_file)
            expected_result = Icalendar::Calendar.parse(cal_file)
            expected_result = expected_result.first.to_ical

            calendar = described_class.call(pbl: pbl, spreadsheet: spreadsheet, year: year, clin: clin)
            calendar.events.each { |event| event.uid = '00000000-0000-0000-0000-000000000000' }

            expect(expected_result).to eq(calendar.to_ical)
          end
        end

        include_examples 'create calendar for', 'K', '20', 1, 'test/fixtures/files/example_one_year_one.ics'
        include_examples 'create calendar for', 'E', '5', 1, 'test/fixtures/files/example_two_year_one.ics'
        include_examples 'create calendar for', 'A', '2', 1, 'test/fixtures/files/example_three_year_one.ics'
      end

      context 'year two' do
        let(:spreadsheet) { Roo::Excelx.new('test/fixtures/files/test_timetable_year_two.xlsx') }

        before do
          Time.zone = 'Australia/Sydney'
          travel_to Time.zone.local(2024, 0o4, 16, 0, 0, 0)
        end

        shared_examples 'create calendar for' do |pbl, year, expected_result_file|
          it 'creates the correct events' do
            cal_file = File.open(expected_result_file)
            expected_result = Icalendar::Calendar.parse(cal_file)
            expected_result = expected_result.first.to_ical

            calendar = described_class.call(pbl: pbl, spreadsheet: spreadsheet, year: year)
            calendar.events.each { |event| event.uid = '00000000-0000-0000-0000-000000000000' }

            expect(expected_result).to eq(calendar.to_ical)
          end
        end

        include_examples 'create calendar for', 'K', 2, 'test/fixtures/files/example_one_year_two.ics'
        include_examples 'create calendar for', 'E', 2, 'test/fixtures/files/example_two_year_two.ics'
        include_examples 'create calendar for', 'A', 2, 'test/fixtures/files/example_three_year_two.ics'
      end
    end
  end
end
