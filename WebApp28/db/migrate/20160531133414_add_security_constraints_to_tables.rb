class AddSecurityConstraintsToTables < ActiveRecord::Migration
  def up
    ## Add foreign key from events.user_id to users.id
    add_foreign_key :events, :users

    ## Check needed >= 0
    execute "ALTER TABLE events ADD CONSTRAINT needed_gteq_zero CHECK (needed >= 1);"

    ## Check start_time < end_time
    execute "ALTER TABLE events ADD CONSTRAINT logical_times CHECK (start_time < end_time);"

    ## Check minimum participants >= 2 when it isn't null
    execute "ALTER TABLE events ADD CONSTRAINT min_participants_gteq_two CHECK ((min_participants < 2) IS NOT TRUE);"

    ## Check university_location is in university_mails.university_name
    execute "CREATE FUNCTION check_university_is_valid() RETURNS trigger AS $$
               BEGIN
                 IF NEW.university_location NOT IN (SELECT DISTINCT university_name
                                                    FROM university_mails)
                 THEN RAISE EXCEPTION 'Not a valid university';
                 END IF;
                 RETURN NEW;
               END;
             $$ LANGUAGE plpgsql;"
    execute "CREATE CONSTRAINT TRIGGER existing_university 
             AFTER INSERT OR UPDATE
             ON events
             FOR EACH ROW
             EXECUTE PROCEDURE check_university_is_valid();"

  	## Check participants >= 1
  	execute "ALTER TABLE event_participants ADD CONSTRAINT participants_gteq_one CHECK (participants >= 1);"
    	
  	## Check email has valid ending
    execute "CREATE FUNCTION check_email_is_valid() RETURNS trigger AS $$
               BEGIN
                 IF NOT EXISTS (SELECT *
                                FROM university_mails
                                WHERE NEW.email ILIKE ('%@' || university_mails.mail_extension))
                 THEN RAISE EXCEPTION 'Not a valid email';
                 END IF;
                 RETURN NEW;
               END;
             $$ LANGUAGE plpgsql;"
    execute "CREATE CONSTRAINT TRIGGER existing_email 
             AFTER INSERT OR UPDATE
             ON users
             FOR EACH ROW
             EXECUTE PROCEDURE check_email_is_valid();"
  end

  def down
    remove_foreign_key :events, :users
  	execute "ALTER TABLE events REMOVE CONSTRAINT needed_gteq_zero;"
  	execute "ALTER TABLE events REMOVE CONSTRAINT logical_times;"
    execute "ALTER TABLE events REMOVE CONSTRAINT min_participants_gteq_two;"
    execute "DROP TRIGGER existing_university ON events;"
    execute "DROP FUNCTION check_university_is_valid();"
    execute "ALTER TABLE event_participants REMOVE CONSTRAINT participants_gteq_one;"
    execute "DROP TRIGGER existing_email ON users;"
    execute "DROP FUNCTION check_email_is_valid();"
  end
end
