require 'rails_helper'

RSpec.describe Sport, type: :model do

  describe '#sport database table' do
    sports_list_path = 'app/assets/images/sports/*.png'
    
    it 'should have same # of entries as # of files in images/sports' do
      number_entries = Sport.distinct.count('name')
      number_sport_logos = Dir[sports_list_path].length
      expect(number_entries).to eq(number_sport_logos)
    end

    it 'should have an entry assiocated to the logo file' do
      Dir.glob(sports_list_path) do |sport_logo|
        sport = File.basename(sport_logo, ".png").titleize
        expect{Sport.find(sport)}.to_not raise_exception
      end
    end

    it 'should not have an entry' do
      expect{Sport.find('cooking')}.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

end
