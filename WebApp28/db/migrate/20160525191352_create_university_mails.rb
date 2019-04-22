require 'university/mail_university_hash_generator'
require 'university/university_country'

class CreateUniversityMails < ActiveRecord::Migration
  include MailUniversityHashGenerator, UniversityCountry

  def up
    ## Create the table storing a mail extension and which gives us a
    ## university name (eg: ic.ac.uk)
    create_table :university_mails, id: false do |t|
      t.string :mail_extension, primary_key: true, null: false
      t.string :university_name, null: false
    end

    ## add an index to speed up queries
    add_index :university_mails, :mail_extension, unique: true
  end

  def down
    drop_table :university_mails
  end

end
