require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#email' do
    it 'should fail email validation' do
      user = build(:user, email: 'florian.emile14@gmail.com')
      check_for_failed_validation(user, :email, 1)
    end

    it 'should pass past email validation' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

end
