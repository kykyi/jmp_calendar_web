

require 'rails_helper'

RSpec.describe Calendars::Uon::YearOne::CheckValidEventService do
  shared_examples 'is_valid? for' do |pbl, clin, group_prefix, expected_result|
    it "correctly processes pbl #{pbl}, clin #{clin}, group_prefix #{group_prefix}, to make expected_result #{expected_result}" do
      expect(described_class.is_valid?(pbl: pbl, clin: clin, group_prefix: group_prefix)).to eq expected_result
    end
  end

  describe '#is_valid?' do
    # Test cases for group_prefix "ALL"
    include_examples 'is_valid? for', '', '', 'ALL', true
    include_examples 'is_valid? for', 'A', '1', 'ALL', true
    include_examples 'is_valid? for', 'E', '5', 'ALL', true
    # Edge case for PBL and CLIN outside defined range
    include_examples 'is_valid? for', 'Z', '50', 'ALL', true
    # Test cases for Callaghan campus with "CAL" prefix
    include_examples 'is_valid? for', 'A', '1', 'CAL-ALL', false
    include_examples 'is_valid? for', 'E', '5', 'CAL-ALL', true
    include_examples 'is_valid? for', 'D', '4', 'CAL-ALL', false
    # Test cases for Central Coast campus with "CC" prefix
    include_examples 'is_valid? for', 'E', '5', 'CC-ALL', false
    include_examples 'is_valid? for', 'A', '1', 'CC-ALL', true
    # Test cases for specific PBL and CLIN groups
    include_examples 'is_valid? for', 'A', '2', 'PBL: A', true
    include_examples 'is_valid? for', 'A', '2', 'CLIN: 2', true
    include_examples 'is_valid? for', 'B', '3', 'PBL: A', false
    include_examples 'is_valid? for', 'D', '3', 'PBL: A', false
    include_examples 'is_valid? for', 'D', '3', 'CLIN: 2', false
    include_examples 'is_valid? for', 'D', '3', 'PBL: A+B+C+D', true
    # Test cases for invalid inputs
    include_examples 'is_valid? for', 'bar', 'baz', 'gux', false
    include_examples 'is_valid? for', 'Z', '9', 'XYZ', false  # Completely outside defined criteria
  end
end
