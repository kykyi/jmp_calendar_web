

module Calendars
  module Uon
    module YearOne
      class CheckValidEventService
        def self.is_valid?(pbl:, clin:, group_prefix:)
          new(pbl, clin, group_prefix).call
        end

        def initialize(pbl, clin, group_prefix)
          @pbl = pbl
          @clin = clin
          @group_prefix = group_prefix
        end

        def call
          is_valid?
        end

        private

        def is_valid?
          @pbl = @pbl.downcase if @pbl
          @clin = @clin.downcase if @clin
          @group_prefix = @group_prefix.downcase if @group_prefix

          return true if @group_prefix == 'all'

          campus = if %w[a b c d].include?(@pbl) && %w[1 2 3 4].include?(@clin)
                     'cc'
                   else
                     'cal'
                   end

          return true if campus == 'cc' && @group_prefix == 'cc-all'

          return true if campus == 'cal' && @group_prefix == 'cal-all'
          
          if @group_prefix&.include?('pbl')
            group_prefix = @group_prefix.gsub("pbl", "")
            prefixes = @group_prefix.gsub(/[^0-9a-zA-Z]/, ' ').split(" ")
            return true if prefixes&.any? { |prefix| prefix == @pbl } 
          end

          if @group_prefix&.include?('clin')
            group_prefix = @group_prefix.gsub("clin", "")
            prefixes = @group_prefix.gsub(/[^0-9a-zA-Z]/, ' ').split(" ")
            return true if prefixes&.any? { |prefix| prefix == @clin } 
          end
      
          false
        end
      end
    end
  end
end
