

module Calendars
  module Une
    module YearOne
      class CheckValidEventService
        def self.is_valid?(group:, pbl:, clin:)
          new(group, pbl, clin).call
        end

        def initialize(group, pbl, clin)
          @group = group
          @pbl = pbl
          @clin = clin
        end

        def call
          is_valid?
        end

        private

        def is_valid?
          @group = @group.downcase if @group
          @pbl = @pbl.downcase if @pbl
          @clin = @clin.downcase if @clin

          return unless @group && @pbl && @clin

          if @group.include?('-')
            @group = @group.gsub('clin', '')
            @group.squish!

            part_one, part_two = @group.split('-')

            return true if (part_one..part_two).include?(@pbl) or (part_one..part_two).include?(@clin)
          end

          return true if @group == @pbl

          @group = @group&.split(/\W+/)

          return true if @group&.include?('pbl') && @group&.include?(@pbl)

          return true if @group&.include?('clin') && @group&.include?(@clin)

          false
        end
      end
    end
  end
end
