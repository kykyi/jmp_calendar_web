

module Calendar
  module Uon
    module YearOne
      class CheckValidEventService
        def self.is_valid?(group:, pbl:, clin:, group_prefix:)
          new(group, pbl, clin, group_prefix).call
        end

        def initialize(group, pbl, clin, group_prefix)
          @group = group
          @pbl = pbl
          @clin = clin
          @group_prefix = group_prefix
        end

        def call
          is_valid?
        end

        private

        def is_valid?
          @group = @group.downcase if @group
          @pbl = @pbl.downcase if @pbl
          @clin = @clin.downcase if @clin
          @group_prefix = @group_prefix.downcase if @group_prefix

          return true if @group_prefix == 'all'

          campus = if %w[a b c d].include?(@pbl) && %w[1 2 3 4].include?(@clin)
                     'central coast'
                   else
                     'callaghan'
                   end

          return true if campus == 'callaghan' && @group_prefix == 'cal' && @group == 'all'

          return true if campus == 'central coast' && @group_prefix == 'cc' && @group == 'all'

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
