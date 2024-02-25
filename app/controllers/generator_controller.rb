class GeneratorController < ApplicationController
    def new
    end

    def create
        response = Aws::LambdaClient.call("jmp_calendar", {
            pbl: "K",
            clin: "18",
            key: "MEDI1101A Timetable Weeks 1 to 3 2024 - Callaghan & Central Coast.xlsx"
        })

        calendar = Icalendar::Calendar.parse(response.payload).first.to_ical

        send_data ics_file, filename: 'event.ics', type: 'text/calendar', disposition: 'attachment'
    end

    private

    def form_params
        params.require(:form).permit(:clin, :pbl)
    end
end