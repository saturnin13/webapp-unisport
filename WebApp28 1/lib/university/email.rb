module University
  module Email
    # Rails.root gets the directory of your application (the folder that
    # contains app
    # .join is a concatenation function for file paths i.e. join('config',
    # 'universities.yaml') is equivalent to config/universities.yaml
    UNIVERSITIES = UniversityMail.pluck(:mail_extension)

    # Verifies that email is a valid english university email
    def self.valid?(email)
      UNIVERSITIES.any? { |uni_ext| email.ends_with?("@#{uni_ext}") }
    end
  end
end
