require 'rails_helper'

# NOTE
# These tests are time dependent, as only events with dates greater than Time.zone.today
# are assessed. Keep this in mind if debugging!
RSpec.describe "Spreadsheets contain no errors" do
    shared_examples "a valid combination" do
        it "does not raise an error" do
            expect { Calendars::CreateCalendarService.call(
                uni: uni, pbl: pbl, clin: clin, year: year, spreadsheet: spreadsheet
            )}.not_to raise_error
        end
    end
    describe "UON Year 1" do
        CLIN_OPTS = ("1".."20").to_a
        PBL_OPTS = ("A".."Q").to_a

        let(:uni) { "UON" }
        let(:year) { 1 }
        let(:spreadsheet) { load_spreadsheet(uni, year, "UON MEDI1101A Student Timetable Wk 2 - 14.xlsx") }

        CLIN_OPTS.each do |clin|
            PBL_OPTS.each do |pbl|
                it_behaves_like "a valid combination" do
                    let(:pbl) { pbl }
                    let(:clin) { clin }
                end
            end
        end
    end

    describe "UON Year 2" do
        PBL_OPTS = ("A".."Q").to_a

        let(:uni) { "UON" }
        let(:year) { 2 }
        let(:spreadsheet) { load_spreadsheet(uni, year, "2024MEDI2101ATimetable-CANVAS.xlsx") }

        PBL_OPTS.each do |pbl|
            it_behaves_like "a valid combination" do
                let(:pbl) { pbl }
                let(:clin) { clin }
            end
        end
    end

    describe "UNE Year 1" do
        CLIN_OPTS = ("1".."16").to_a
        PBL_OPTS = ("A".."H").to_a

        let(:uni) { "UNE" }
        let(:year) { 1 }
        let(:spreadsheet) { load_spreadsheet(uni, year, "UNE MEDI1101A Student Timetable Wk 2 - 14.xlsx") }

        CLIN_OPTS.each do |clin|
            PBL_OPTS.each do |pbl|
                it_behaves_like "a valid combination" do
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