class AddParticipantsAndPhoneConstraintsToEvents < ActiveRecord::Migration
def up
  	execute "CREATE FUNCTION check_participants_is_valid_creator() RETURNS trigger AS $$
               BEGIN
                 IF EXISTS
                    (WITH helper AS
                      (SELECT SUM (CASE WHEN event_participants.confirmed
                                        THEN event_participants.participants ELSE 0 END)
                              OVER (PARTITION BY event_participants.event_id) AS confirmed_participants,
                              events.needed AS needed,
                              events.id AS event_id
                       FROM events JOIN event_participants ON events.id = event_participants.event_id)
                     SELECT *
                     FROM helper
                     WHERE helper.confirmed_participants > helper.needed
                     AND   helper.event_id = NEW.id)
                 THEN RAISE EXCEPTION 'Too many participants';
                 END IF;
                 RETURN NEW;
               END;
             $$ LANGUAGE plpgsql;"
    execute "CREATE CONSTRAINT TRIGGER valid_participants_creator 
             AFTER INSERT OR UPDATE
             ON events
             FOR EACH ROW
             EXECUTE PROCEDURE check_participants_is_valid_creator();"

    execute "CREATE FUNCTION check_creator_has_phone_number() RETURNS trigger AS $$
               BEGIN
                 IF NOT EXISTS
                    (WITH helper AS
                       (SELECT users.telephone_number,
                               events.user_id,
                               events.id AS event_id
                        FROM users JOIN events ON users.id = events.user_id)
                     SELECT *
                     FROM helper
                     WHERE helper.user_id = NEW.user_id
                     AND   helper.event_id = NEW.id
                     AND   helper.telephone_number IS NOT NULL)
                 THEN RAISE EXCEPTION 'Creator has not given his telephone number.';
                 END IF;
                 RETURN NEW;
               END;
             $$ LANGUAGE plpgsql;"
    execute "CREATE CONSTRAINT TRIGGER phone_number_given_creator
             AFTER INSERT OR UPDATE
             ON events
             FOR EACH ROW
             EXECUTE PROCEDURE check_creator_has_phone_number();"
  end

  def down
    execute "DROP TRIGGER valid_participants_creator ON events;"
  	execute "DROP FUNCTION check_participants_is_valid_creator();"
    execute "DROP TRIGGER phone_number_given_creator ON events;"
    execute "DROP FUNCTION check_creator_has_phone_number();"
  end
end
