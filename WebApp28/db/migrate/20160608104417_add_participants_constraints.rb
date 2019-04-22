class AddParticipantsConstraints < ActiveRecord::Migration
  def up
  	execute "CREATE FUNCTION check_participants_is_valid() RETURNS trigger AS $$
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
                     AND   helper.event_id = NEW.event_id)
                 THEN RAISE EXCEPTION 'Too many participants';
                 END IF;
                 RETURN NEW;
               END;
             $$ LANGUAGE plpgsql;"
    execute "CREATE CONSTRAINT TRIGGER valid_participants 
             AFTER INSERT OR UPDATE
             ON event_participants
             FOR EACH ROW
             EXECUTE PROCEDURE check_participants_is_valid();"
  end

  def down
    execute "DROP TRIGGER valid_participants ON event_participants;"
  	execute "DROP FUNCTION check_participants_is_valid();"
  end
end
