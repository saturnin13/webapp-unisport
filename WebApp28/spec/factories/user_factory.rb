FactoryGirl.define do
  factory :user do
    email 'fre14@ic.ac.uk'
    ## password and encrypted_password do not match
    encrypted_password '123456GHW'
    password '123456'
  end
end
