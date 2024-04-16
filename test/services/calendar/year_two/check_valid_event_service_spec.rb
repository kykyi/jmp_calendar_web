require 'rails_helper'

RSpec.describe Calendar::YearTwo::CheckValidEventService do
    shared_examples "is_valid? for" do |group, pbl, campus, expected_result|
        it "correctly processes group #{group}, pbl #{pbl}, campus #{campus}, to make expected_result #{expected_result}" do
          expect(described_class.is_valid?(group: group, pbl: pbl, campus: campus)).to eq expected_result
        end
    end

    describe "#is_valid?" do

        include_examples "is_valid? for", "", "", "cal/cc", true
        include_examples "is_valid? for", "", "", "cc", false
        include_examples "is_valid? for", "", "", "cal", false

        include_examples "is_valid? for", "E-J", "F", "cal", true
        include_examples "is_valid? for", "E-J", "P", "cal", false

        include_examples "is_valid? for", "A-C", "B", "cc", true
        include_examples "is_valid? for", "A-C", "D", "cc", false

        include_examples "is_valid? for", "all", "E", "cal", true
        include_examples "is_valid? for", "all", "A", "cc", true

        include_examples "is_valid? for", "A", "A", "", true
        include_examples "is_valid? for", "B", "B", "", true

        include_examples "is_valid? for", "", "Q", "", false


        # Specific tests for PBLs within A-D range and campus "CC"
        ('A'..'D').each do |pbl|
            include_examples "is_valid? for", "all", pbl, "cc", true
            include_examples "is_valid? for", "all", pbl, "cal", false
        end

        # Specific tests for PBLs within E-P range and campus "CAL"
        ('E'..'P').each do |pbl|
            include_examples "is_valid? for", "all", pbl, "cal", true
            include_examples "is_valid? for", "all", pbl, "cc", false
        end
    end

end