class CalendarsController < ApplicationController
    def new
        s3 = Aws::S3::Client.new(region: "ap-southeast-2", access_key_id: ENV["AWS_LAMBDA_ACCESS_KEY"],secret_access_key: ENV["AWS_LAMBDA_SECRET_KEY"])
        items = s3.list_objects(bucket: 'jmp-timetables', max_keys: 50).first.contents
        @spreadsheet_options = items.map(&:key)
    end

    def create
        if form_params[:pbl] == "" || form_params[:clin] == ""
            flash[:alert] = "You must choose both a pbl and a clin"
            redirect_to :root and return
        end

        response = Aws::S3SpreadsheetClient.call("jmp-timetables", form_params[:spreadsheet])

        calendar = Calendar::CreateCalendarService.call(
            pbl: form_params[:pbl],
            clin: form_params[:clin],
            year: 1,
            spreadsheet: response.xlsx
        )

        calendar = calendar.to_ical

        calendar_name = "pbl_#{form_params[:pbl]}_clin_#{form_params[:clin]}_#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.ics"

        send_data calendar, type: 'text/calendar', filename: calendar_name
        rescue StandardError => e
            Sentry.capture_exception(e)
            flash[:alert] = "Something went wrong"
            redirect_to :root and return
    end

    private

    def form_params
        params.require(:user_input).permit(:clin, :pbl, :spreadsheet)
    end
end