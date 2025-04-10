

class TimeService
  def self.parse_time(date, time_str, is_start)
    date_str = if date.is_a?(Date)
                 date.strftime('%Y-%m-%d')
               else
                 date
               end

    time_str.downcase!
    time_str.strip!

    # Allow for silly times given in the time column
    time_str = '12pm - 1pm' if ['tba', 'self directed learning', 'self-directed', 'self directed',
                                'as timetabled on canvas', "please refer to \nosce timetable"].include?(time_str)

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

    # Allow for times like 11-12pm
    time_format = if chosen_time.include?('am') || chosen_time.include?('pm')
                    chosen_time.include?('.') ? '%Y-%m-%d %I.%M%p' : '%Y-%m-%d %I%p'
                  else
                    chosen_time.include?('.') ? '%Y-%m-%d %H.%M' : '%Y-%m-%d %H'
                  end

    time_obj = Time.strptime("#{date_str} #{chosen_time}", time_format)

    time_obj.to_datetime
  end
end
