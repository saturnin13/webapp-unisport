require 'rails_helper'

RSpec.describe EventParticipant, type: :model do

  describe '#participants validation' do
    it 'should fail number of participants validation' do
      participant = build(:event_participant, participants: 0)
      check_for_failed_validation(participant, :participants, 1)
    end

    it 'should pass number of participants validation' do
      participant = build(:event_participant)
      expect(participant).to be_valid
    end
  end

end
