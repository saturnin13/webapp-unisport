require 'rails_helper'
require 'university/mail_university_hash_generator'
require 'university/university_country'

RSpec.describe MailUniversityHashGenerator do

  it "generator creates a hash mapping mail extension to english university" do
    # generate the hash
    mail_university_hash =
      MailUniversityHashGenerator.generate_mail_university_hash(
        UniversityCountry::ENGLAND)

    # check if some extension/university are present
    imperial_ext = "ic.ac.uk"
    expect(mail_university_hash.key?(imperial_ext)).to eq(true)
    expect(mail_university_hash[imperial_ext]).to eq("Imperial College London")

    aberdeen_ext = "abdn.ac.uk"
    expect(mail_university_hash.key?(aberdeen_ext)).to eq(true)
    expect(mail_university_hash[aberdeen_ext]).to eq("University of Aberdeen")

    york_ext = "york.ac.uk"
    expect(mail_university_hash.key?(york_ext)).to eq(true)
    expect(mail_university_hash[york_ext]).to eq("University of York")
  end

end
