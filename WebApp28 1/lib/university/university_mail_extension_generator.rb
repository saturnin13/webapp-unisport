module UniversityMailExtensionGenerator

  def self.generate_university_mail_extensions
    possible_email_ext = Regexp.union(UniversityMail.pluck(:mail_extension))
    /\A([\w+\-]\.?)+@#{possible_email_ext}\z/i
  end

end
