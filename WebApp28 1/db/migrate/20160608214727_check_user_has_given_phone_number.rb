class CheckUserHasGivenPhoneNumber < ActiveRecord::Migration
  def up
  	execute "CREATE FUNCTION check_user_has_phone_number() RETURNS trigger AS $$
               BEGIN
                 IF NOT EXISTS
                    (WITH helper AS
                       (SELECT users.telephone_number,
                               event_participants.user_id,
                               event_participants.event_id
                        FROM users JOIN event_participants ON users.id = event_participants.user_id)
                     SELECT *
                     FROM helper
                     WHERE helper.user_id = NEW.user_id
                     AND   helper.event_id = NEW.event_id
                     AND   helper.telephone_number IS NOT NULL)
                 THEN RAISE EXCEPTION 'User has not given his telephone number.';
                 END IF;
                 RETURN NEW;
               END;
             $$ LANGUAGE plpgsql;"
    execute "CREATE CONSTRAINT TRIGGER phone_number_given
             AFTER INSERT OR UPDATE
             ON event_participants
             FOR EACH ROW
             EXECUTE PROCEDURE check_user_has_phone_number();"
  end

  def down
    execute "DROP TRIGGER phone_number_given ON event_participants;"
  	execute "DROP FUNCTION check_user_has_phone_number();"
  end
end
