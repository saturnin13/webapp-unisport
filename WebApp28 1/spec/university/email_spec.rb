require 'rails_helper'

RSpec.describe(University::Email) do

  describe '.valid?' do
    context 'with a valid university email' do
      it 'is true' do
        expect(University::Email.valid?('fre14@imperial.ac.uk')).to be(true)
      end
    end

    context 'with non-university email' do
      it 'is false' do
        expect(University::Email.valid?('lmj112@gmail.com')).to be(false)
      end
    end
  end
end
