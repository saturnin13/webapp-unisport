FactoryGirl.define do
  factory :event do
    sport 'Football'
    start_time '20:00:00'
    end_time '21:00:00'
    date Date.tomorrow
    university_location 'Imperial College London'
    needed 4
  end
end
