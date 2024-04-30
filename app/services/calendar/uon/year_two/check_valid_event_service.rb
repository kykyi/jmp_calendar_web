

module Calendar
  module Uon
    module YearTwo
      class CheckValidEventService
        def self.is_valid?(group:, pbl:, campus:)
          new(group, pbl, campus).call
        end

        def initialize(group, pbl, campus)
          @group = group
          @pbl = pbl
          @campus = campus
        end

        def call
          is_valid?
        end

        private

        def is_valid?
          @group = @group.downcase if @group
          @pbl = @pbl.downcase if @pbl
          @campus = @campus.downcase if @campus

          return true if @campus == 'cal/cc'
          return false unless ('a'..'p').to_a.include?(@pbl)

          return false if @campus == 'cal' && ('a'..'d').to_a.include?(@pbl)

          return false if @campus == 'cc' && ('e'..'p').to_a.include?(@pbl)

          return true if @campus == 'cal' && @group == 'all'

          return true if @campus == 'cc' && @group == 'all'

          return true if @group == @pbl && @group != ''

          if @group&.include?('-')
            first_pbl, second_pbl = @group.split('-')
            return true if (first_pbl..second_pbl).include?(@pbl)
          end

          false
        end
      end
    end
  end
end