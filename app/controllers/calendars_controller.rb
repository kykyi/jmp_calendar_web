

class CalendarsController < ApplicationController
  before_action :set_uni_options, only: %i[new update_form]
  before_action :set_defaults, only: %i[new update_form]

  def new
  end

  def update_form
    @uni = params[:uni]
    @year = params[:year]
    @spreadsheet = params[:spreadsheet]
    @pbl = params[:pbl]
    @clin = params[:clin]

    set_instance_vars(@uni, @year, @spreadsheet, @pbl, @clin)

    render turbo_stream: turbo_stream.replace(params[:frame_id], partial: "calendars/form",
    locals: { uni: @uni,
              year: @year,
              spreadsheet: @spreadsheet,
              pbl: @pbl,
              clin: @clin,
              year_options: @year_options,
              uni_options: @uni_options,
              spreadsheet_options: @spreadsheet_options,
              pbl_options: @pbl_options,
              clin_options: @clin_options,
              submit_disabled: @submit_disabled
            })
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
      uni: form_params[:uni].downcase,
      spreadsheet: xlsx
    )

    calendar = calendar.to_ical

    calendar_name = if form_params[:year].to_i == 1
                      "pbl_#{form_params[:pbl]}_clin_#{form_params[:clin]}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.ics"
                    else
                      "pbl_#{form_params[:pbl]}_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.ics"
                    end

    send_data calendar, type: 'text/calendar', filename: calendar_name
  rescue StandardError => e
    Sentry.capture_exception(e)
    flash[:alert] = 'Something went wrong'
    redirect_to :root and return
  end

  private

  def form_params
    params.require(:user_input).permit(:clin, :pbl, :spreadsheet, :year, :uni, :complete)
  end

  def set_instance_vars(uni, year, spreadsheet, pbl, clin)
    if uni == 'UON'
      @year_options = [1,2]
    elsif uni == 'UNE'
      @year_options = [1]
    end

    if uni && year
      @spreadsheet_options = get_spreadsheet_options_for(uni, year)
    end

    if spreadsheet
      if uni == "UNE"
        @pbl_options =  ("A".."H").to_a
        @clin_options =  ("1".."16").to_a
      elsif uni == "UON"
        @pbl_options =  ("A".."Q").to_a
        if year == "1"
          @clin_options =  ("1".."20").to_a
        end
      end
    end

    if year == "1"
      @submit_disabled = !uni || !year || !spreadsheet || !pbl || !clin
    else
      @submit_disabled = !uni || !year || !spreadsheet || !pbl
    end

  end

  def get_spreadsheet_options_for(uni="*", year="*")
    Dir.glob("lib/assets/spreadsheets/#{uni.downcase}/#{year}/*").map do |f|
      f.split("/").last
    end
  end

  def set_uni_options
    @uni_options = ["UNE", "UON"]
  end

  def set_defaults
    @uni ||= nil
    @year ||= nil
    @spreadsheet ||= nil
    @year_options ||= []
    @uni_options ||= []
    @spreadsheet_options ||= []
    @pbl_options ||= []
    @clin_options ||= []
    @submit_disabled ||= true
  end
end
