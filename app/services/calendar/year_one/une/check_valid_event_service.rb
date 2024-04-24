# frozen_string_literal: true

module Calendar
  module YearOne
    module Une
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

          return false if ('a'..'h').to_a.include?(@pbl)

          if @group.include?('-')
            @group = @group.gsub('clin', '')
            @group.squish!

            part_one, part_two = @group.split('-')

            return true if (part_one..part_two).include?(@pbl)
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
