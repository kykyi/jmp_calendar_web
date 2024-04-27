# frozen_string_literal: true

class CalendarsController < ApplicationController
  def new
    @spreadsheet_options = Dir.glob("lib/assets/spreadsheets/*/*/*").map do |f|
      f.split("/").last
    end
  end

  def create
    if form_params[:year] == '1' && (form_params[:pbl] == '' || form_params[:clin] == '')
      flash[:alert] = 'Year 1 students must choose both a pbl and a clin'
      redirect_to :root and return
    end

    if form_params[:year] == '2' && form_params[:pbl] == ''
      flash[:alert] = 'Year 2 students must choose a pbl'
      redirect_to :root and return
    end

    full_form_file_name = "lib/assets/spreadsheets/#{form_params[:uni].downcase}/#{form_params[:year]}/#{form_params[:spreadsheet]}"

    xlsx =  Roo::Excelx.new(full_form_file_name)

    calendar = Calendar::CreateCalendarService.call(
      pbl: form_params[:pbl],
      clin: form_params[:clin],
      year: form_params[:year].to_i,
      uni: form_params[:uni],
      spreadsheet: xlsx
    )

    calendar = calendar.to_ical

    calendar_name = if form_params[:year].to_i == 1
                      "pbl_#{form_params[:pbl]}_clin_#{form_params[:clin]}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.ics"
                    else
                      "pbl_#{form_params[:pbl]}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.ics"
                    end

    send_data calendar, type: 'text/calendar', filename: calendar_name
  # rescue StandardError => e
  #   Sentry.capture_exception(e)
  #   flash[:alert] = 'Something went wrong'
  #   redirect_to :root and return
  end

  private

  def form_params
    params.require(:user_input).permit(:clin, :pbl, :spreadsheet, :year, :uni)
  end
end
