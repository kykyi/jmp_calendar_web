module Calendar
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

                return true if @group_prefix == "all"

                if ["a", "b", "c", "d"].include?(@pbl) && ["1", "2", "3", "4"].include?(@clin)
                  campus = "central coast"
                else
                  campus = "callaghan"
                end

                if campus == "callaghan" && @group_prefix == "cal" && @group == "all"
                  return true
                end

                if campus == "central coast" && @group_prefix == "cc" && @group == "all"
                  return true
                end

                return true if @group == @pbl

                @group = @group&.split(/\W+/)

                if @group&.include?("pbl") && @group&.include?(@pbl)
                  return true
                end

                if @group&.include?("clin") && @group&.include?(@clin)
                  return true
                end

                false
            end
        end
    end
end

