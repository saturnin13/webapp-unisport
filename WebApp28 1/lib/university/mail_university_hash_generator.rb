require 'university/university_country'

module MailUniversityHashGenerator
  include UniversityCountry

  def self.generate_mail_university_hash(university_country)
    university_table = Hash.new
    universities_path = UniversityCountry.get_universities_path(university_country)

    Dir.glob(universities_path) do |f|
      file = File.open(f, "r")

      data = file.read.chomp
      university_mail_ext = "#{File.basename(f, ".txt")}.ac.uk"
      university_table[university_mail_ext] = data

      file.close
    end

    university_table
  end

end
