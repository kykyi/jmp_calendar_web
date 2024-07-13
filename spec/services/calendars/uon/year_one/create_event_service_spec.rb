

require 'rails_helper'

RSpec.describe Calendars::Uon::YearOne::CreateEventService do
  describe '.call' do
    subject(:create_event) { described_class.call(pbl: pbl, clin: pbl, row: row, calendar: calendar) }
    let(:calendar) { Icalendar::Calendar.new }
    let(:row) do
      {
        'Venue' => 'Main Hall',
        "Students\nCAL-ALL= Entire Callaghan cohort\nCC-ALL = Entire CCoast cohort" => 'ALL',
        'Date' => '2024-04-11',
        'Time' => '10am-12pm',
        'Session' => 'Introduction Session',
        'Domain' => 'Education',
        "Attendance\n(M =\nmandatory)" => 'M',
        'url' => 'www.example.com'
      }
    end
    let(:pbl) { 'A' }
    let(:clin) { '1' }

    before do
      Time.zone = 'Sydney'
      travel_to Time.zone.local(2024, 0o4, 10)
    end

    it 'creates a new event on the calendar' do
      expect { create_event }.to change { calendar.events.count }.by(1)
    end

    it 'creates an event with the correct details', :aggregate_failures do
      create_event

      event = calendar.events.first

      expect(event.dtstart).to eq Time.zone.local(2024, 0o4, 11, 10, 0o0, 0o0)
      expect(event.dtend).to eq Time.zone.local(2024, 0o4, 11, 12, 0o0, 0o0)
      expect(event.summary).to eq 'Introduction Session - Education (ALL)'
      expect(event.description).to eq nil
      expect(event.location).to eq 'Main Hall'
      expect(event.url.to_s).to eq 'www.example.com'
    end
  end
end
