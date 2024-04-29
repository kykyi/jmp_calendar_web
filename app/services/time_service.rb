class TimeService
  def self.parse_time(date, time_str, is_start)
    date_str = if date.is_a?(Date)
                 date.strftime('%Y-%m-%d')
               else
                 date
               end

    time_str.downcase!

    # Allow for silly times given in the time column
    time_str = '12pm - 1pm' if ["self directed learning", 'self-directed', 'self directed', 'as timetabled on canvas'].include?(time_str)

    start_time, end_time = if time_str.include?(' - ')
                             time_str.split(' - ')
                           elsif time_str.include?('- ')
                             time_str.split('- ')
                           elsif time_str.include?('-')
                             time_str.split('-')
                           else
                             [nil, nil]
                           end

    chosen_time = is_start ? start_time : end_time

    chosen_time = '12pm' if chosen_time == '12md'


    chosen_time.tr!(':', '.')
    chosen_time.delete!(' ')

    time_format = chosen_time.include?('.') ? '%Y-%m-%d %I.%M%p' : '%Y-%m-%d %I%p'
    time_obj = Time.strptime("#{date_str} #{chosen_time}", time_format)

    time_obj.to_datetime
  end
end
