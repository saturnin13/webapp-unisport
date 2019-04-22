require 'rails_helper'
require 'sports/sports_hash_generator'

RSpec.describe SportsHashGenerator do

  it "generator creates a hash mapping sports to images" do
    # generate the hash
    sports_hash = SportsHashGenerator.generate_sports_hash

    # check if some extension/university are present/absent
    sport = "Football"
    expect(sports_hash.key?(sport)).to eq(true)
    path = ActionController::Base.helpers.path_to_image("#{sport.downcase}.png")
    expect(sports_hash[sport]).to eq(path)

    sport = "Basketball"
    expect(sports_hash.key?(sport)).to eq(true)
    path = ActionController::Base.helpers.path_to_image("#{sport.downcase}.png")
    expect(sports_hash[sport]).to eq(path)

    sport = "Cooking"
    expect(sports_hash.key?(sport)).to eq(false)
  end

end
