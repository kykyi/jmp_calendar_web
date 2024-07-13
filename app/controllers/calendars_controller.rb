# frozen_string_literal: true

class CalendarsController < ApplicationController
  before_action :set_uni_options, only: %i[new update_form]
  before_action :set_defaults, only: %i[new update_form]

  def new; end

  def update_form
    @uni = params[:uni]
    @year = params[:year]
    @spreadsheet = params[:spreadsheet]
    @pbl = params[:pbl]
    @clin = params[:clin]

    set_instance_vars(@uni, @year, @spreadsheet, @pbl, @clin)

    render turbo_stream: turbo_stream.replace(params[:frame_id], partial: 'calendars/form',
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
                                                                           submit_disabled: @submit_disabled,
                                                                           exclude_pbl_and_clin: @exclude_pbl_and_clin })
  end

  def create
    full_form_file_name = "lib/assets/spreadsheets/#{form_params[:uni].downcase}/#{form_params[:year]}/#{form_params[:spreadsheet]}"

    xlsx = Roo::Excelx.new(full_form_file_name)

    calendar = Calendars::CreateCalendarService.call(
      pbl: form_params[:pbl],
      clin: form_params[:clin],
      year: form_params[:year].to_i,
      uni: form_params[:uni].downcase,
      spreadsheet: xlsx
    )

    calendar = calendar.to_ical

    calendar_name = "timetable_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.ics"

    Calendar.create(raw: calendar, pbl: form_params[:pbl].downcase, clin: form_params[:clin], year: form_params[:year],
                    uni: form_params[:uni].downcase, spreadsheet: form_params[:spreadsheet])

    send_data calendar, type: 'text/calendar', filename: calendar_name
  rescue StandardError => e
    Sentry.capture_exception(e)
    flash[:alert] = 'Something went wrong'
    redirect_to :root and return
  end

  private

  def form_params
    params.require(:user_input).permit(:clin, :pbl, :spreadsheet, :year, :uni, :complete, :exclude_pbl_and_clin)
  end

  def set_instance_vars(uni, year, spreadsheet, _pbl, _clin)
    if uni == 'UON'
      @year_options = [1, 2]
    elsif uni == 'UNE'
      @year_options = [1]
    end

    @spreadsheet_options = get_spreadsheet_options_for(uni, year) if uni && year

    if spreadsheet
      if uni == 'UNE'
        @pbl_options = ('A'..'H').to_a
        @clin_options = ('1'..'16').to_a
      elsif uni == 'UON'
        @pbl_options = ('A'..'Q').to_a
        @clin_options = ('1'..'20').to_a if year == '1'
      end
    end

    @submit_disabled = !uni || !year || !spreadsheet
  end

  def get_spreadsheet_options_for(uni = '*', year = '*')
    Dir.glob("lib/assets/spreadsheets/#{uni.downcase}/#{year}/*").map do |f|
      f.split('/').last
    end
  end

  def set_uni_options
    @uni_options = %w[UON UNE]
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
    @set_defaults ||= nil
  end
end
