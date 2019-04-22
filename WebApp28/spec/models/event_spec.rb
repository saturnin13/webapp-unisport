require 'rails_helper'

RSpec.describe Event, type: :model do

  describe '#date' do
    it 'should fail past date validation' do
      event = build(:event, date: Date.yesterday)
      check_for_failed_validation(event, :date, 1)
    end

    it 'should pass past date validation' do
      event = build(:event)
      expect(event).to be_valid
    end
  end

  describe '#start_time' do
    it 'should pass time are logical validation' do
      event = build(:event, start_time: '22:00:00')
      check_for_failed_validation(event, :end_time, 1)
    end

    it 'should pass time are logical validation' do
      event = build(:event)
      expect(event).to be_valid
    end
  end

  describe '#end_time' do
    it 'should fail time are logical validation' do
      event = build(:event, end_time: '19:00:00')
      check_for_failed_validation(event, :end_time, 1)
    end

    it 'should pass time are logical validation' do
      event = build(:event)
      expect(event).to be_valid
    end
  end

  describe '#min_participants' do
    it 'should fail minimum number of participants validation' do
      event = build(:event, min_participants: 1)
      check_for_failed_validation(event, :min_participants, 1)
    end

    it 'should pass university location validation' do
      event = build(:event, min_participants: 10)
      expect(event).to be_valid
    end
  end

  describe '#university_location' do
    it 'should fail university location validation' do
      event = build(:event, university_location:'Jupiter')
      check_for_failed_validation(event, :university_location, 1)
    end

    it 'should pass university location validation' do
      event = build(:event)
      expect(event).to be_valid
    end
  end

  describe '#sport' do
    it 'should fail sport validation' do
      event = build(:event, sport: 'Cooking')
      check_for_failed_validation(event, :sport, 1)
    end

    it 'should pass sport validation' do
      event = build(:event)
      expect(event).to be_valid
    end
  end

end
