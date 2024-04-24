require 'rails_helper'

RSpec.describe Calendar::YearOne::Uon::CheckValidEventService do
    shared_examples "is_valid? for" do |group, pbl, clin, group_prefix, expected_result|
        it "correctly processes group #{group}, pbl #{pbl}, clin #{clin}, group_prefix #{group_prefix}, to make expected_result #{expected_result}" do
          expect(described_class.is_valid?(group: group, pbl: pbl, clin: clin, group_prefix: group_prefix)).to eq expected_result
        end
      end

      describe "#is_valid?" do
        # Test cases for group_prefix "ALL"
        include_examples "is_valid? for", "", "", "", "ALL", true
        include_examples "is_valid? for", "ALL", "A", "1", "ALL", true
        # Edge case for PBL and CLIN outside defined range
        include_examples "is_valid? for", "ALL", "E", "5", "ALL", true
        # Test cases for Callaghan campus with "CAL" prefix
        include_examples "is_valid? for", "ALL", "A", "1", "CAL", false
        include_examples "is_valid? for", "A", "A", "1", "CAL", true
        include_examples "is_valid? for", "ALL", "D", "4", "CAL", false
        include_examples "is_valid? for", "PBL A", "A", "1", "CAL", true
        include_examples "is_valid? for", "CLIN 4", "D", "4", "CAL", true
        include_examples "is_valid? for", "ALL", "E", "5", "CAL", true
        # Test cases for Central Coast campus with "CC" prefix
        include_examples "is_valid? for", "ALL", "E", "5", "CC", false
        include_examples "is_valid? for", "PBL E", "E", "5", "CC", true
        include_examples "is_valid? for", "CLIN 5", "E", "5", "CC", true
        include_examples "is_valid? for", "ALL", "A", "1", "CC", true
        # Test cases for specific PBL and CLIN groups
        include_examples "is_valid? for", "PBL B", "B", "2", "", true
        include_examples "is_valid? for", "CLIN 3", "C", "3", "", true
        include_examples "is_valid? for", "PBL C", "C", "", "", true
        include_examples "is_valid? for", "CLIN 1", "", "1", "", true
        include_examples "is_valid? for", "PBL D+CLIN 4", "D", "4", "", true  # Combined PBL and CLIN in group
        # Test cases for mismatched PBL/CLIN and group
        include_examples "is_valid? for", "PBL A", "B", "", "", false
        include_examples "is_valid? for", "CLIN 2", "", "3", "", false
        # Test cases for invalid inputs
        include_examples "is_valid? for", "foo", "bar", "baz", "gux", false
        include_examples "is_valid? for", "", "Z", "9", "XYZ", false  # Completely outside defined criteria
      end

end