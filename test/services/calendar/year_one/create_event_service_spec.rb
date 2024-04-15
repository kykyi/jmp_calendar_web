require 'rails_helper'

RSpec.describe Calendar::YearOne::CreateEventService do
    describe ".call" do
        subject(:create_event) { described_class.call(pbl: pbl, clin: pbl, row: row, calendar: calendar) }
        let(:calendar) { Icalendar::Calendar.new }
        let(:row) do
            {
              "Venue"=> "Main Hall",
              "Group Letter / Number"=> "A",
              "Group Prefix\nCAL=\nCallaghan\nCC=\nCentral Coast\nALL=\nall campuses"=> "CAL",
              "Date"=> "2022-10-01",
              "Time"=> "10am-12pm",
              "Name of Activity "=> "Introduction Session",
              "Domain"=> "Education",
              "Attendance\n(M =\nmandatory)"=> "M",
              "url"=> "www.example.com"
            }
        end
        let(:pbl) { "A"}
        let(:clin) { "1"}

        it "creates a new event on the calendar" do
            expect{create_event}.to change { calendar.events.count }.by(1)
        end

        it "creates an event with the correct details", :aggregate_failures do
            create_event

            event = calendar.events.first
        end
    end
end