
require 'rails_helper'

RSpec.describe "Complete the landing form" do
    describe "UON Year 1" do
        context "when the PBL and CLIN are chosen" do
            it "sends an ics file to the browser" do
                visit "/"

                select "UON", from: "uni"
                select "1", from: "year"
                select "test_timetable_year_one.xlsx", from: "spreadsheet"
                select "K", from: "pbl"
                select "20", from: "clin"

                click_on 'Submit'


                expect(page.response_headers['Content-Type']).to include('text/calendar')
            end
        end
        xcontext "when no PBL or CLIN are chosen"
    end
end