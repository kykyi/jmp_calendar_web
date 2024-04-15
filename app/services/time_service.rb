class TimeService
    def self.parse_time(date, time_str, is_start, time_zone="Australia/Sydney")
        date_str = Date.strptime(date, '%Y-%m-%d')
        time_str.downcase!

        time_str = '12pm - 1pm' if time_str == 'self-directed'

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

        time_obj.in_time_zone(time_zone).to_datetime
    end
end