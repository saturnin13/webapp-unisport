require 'university/mail_university_hash_generator'
require 'university/university_country'
require 'sports/sports_hash_generator'

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db
# with db:setup).

universities_hash = MailUniversityHashGenerator.generate_mail_university_hash(
                      UniversityCountry::ENGLAND)
universities_hash.each do |ext, name|
  uni_mail = UniversityMail.find_by mail_extension: ext
  if uni_mail == nil
    UniversityMail.create(mail_extension: ext, university_name: name)
  elsif uni_mail != nil && uni_mail.university_name != name
    uni_mail.update(university_name: name)
  end
end

sports_hash = SportsHashGenerator.generate_sports_hash()
sports_hash.each do |name, image_path|
  sport = Sport.find_by name: name
  if sport == nil
    Sport.create(name: name, image_path: image_path)
  elsif
    sport.update(image_path: image_path)
  end
end
