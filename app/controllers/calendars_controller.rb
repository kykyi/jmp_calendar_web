class CalendarsController < ApplicationController
    def new
    end

    def create
        if form_params[:pbl] == "" || form_params[:clin] == ""
            flash[:alert] = "You must choose both a pbl and a clin"
            render :new and return
        end

        response = Aws::LambdaClient.call("jmp_calendar", {
            pbl: form_params[:pbl],
            clin: form_params[:clin],
            key: "MEDI1101A Timetable Weeks 1 to 3 2024 - Callaghan & Central Coast.xlsx"
        })

        calendar = Icalendar::Calendar.parse(response.payload).first.to_ical

        calendar_name = "pbl_#{form_params[:pbl]}_clin_#{form_params[:clin]}_#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.ics"

        send_data calendar, type: 'text/calendar', filename: calendar_name
    end

    private

    def form_params
        params.permit(:clin, :pbl)
    end
end