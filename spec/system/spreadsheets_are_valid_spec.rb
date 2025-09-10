

require 'rails_helper'

# NOTE
# These tests are time dependent, as only events with dates greater than Time.zone.today
# are assessed. Keep this in mind if debugging!
RSpec.describe 'Spreadsheets contain no errors' do
  shared_examples 'a valid combination' do
    it 'does not raise an error' do
      expect do
        Calendars::CreateCalendarService.call(
          uni: uni, pbl: pbl, clin: clin, year: year, spreadsheet: spreadsheet
        )
      end.not_to raise_error
    end
  end
  describe 'UON Year 1' do
    let(:uni) { 'UON' }
    let(:year) { 1 }
    let(:spreadsheet) do
      load_spreadsheet(uni, year,
                       'MEDI1101A Callaghan & Central Coast - Timetable - 2025 - Week 1&2 for Canvas.xlsx')
    end

    ('1'..'20').to_a.each do |clin|
      ('A'..'Q').to_a.each do |pbl|
        it_behaves_like 'a valid combination' do
          let(:pbl) { pbl }
          let(:clin) { clin }
        end
      end
    end
  end

  describe 'UON Year 2' do
    let(:uni) { 'UON' }
    let(:year) { 2 }
    let(:spreadsheet) { load_spreadsheet(uni, year, '2025 MEDI2101B Timetable - CANVAS-252cd8ae-0a58-40ab-b0bf-009ae64e2a49.xlsx') }

    ('A'..'Q').to_a.each do |pbl|
      it_behaves_like 'a valid combination' do
        let(:pbl) { pbl }
        let(:clin) { nil }
      end
    end
  end

  describe 'UNE Year 1' do
    let(:uni) { 'UNE' }
    let(:year) { 1 }
    let(:spreadsheet) { load_spreadsheet(uni, year, 'UNE MEDI1101A Student Timetable Wk 2 - 14.xlsx') }

    ('1'..'16').to_a.each do |clin|
      ('A'..'H').to_a.each do |pbl|
        it_behaves_like 'a valid combination' do
          let(:pbl) { pbl }
          let(:clin) { clin }
        end
      end
    end
  end
end

def load_spreadsheet(uni, year, name)
  full_form_file_name = "lib/assets/spreadsheets/#{uni.downcase}/#{year}/#{name}"
  Roo::Excelx.new(full_form_file_name)
end
