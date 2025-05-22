CREATE OR REPLACE FUNCTION check_rating_update()
RETURNS trigger AS $$
DECLARE 
	_courier_rating numeric;
BEGIN
	SELECT courier_rating INTO _courier_rating
	FROM courier
	WHERE courier_id = NEW.courier_id;

	IF _courier_rating < 4.10 THEN
		UPDATE courier
		SET courier_is_busy_with_order = true
		WHERE courier_id = NEW.courier_id;

		EXECUTE format('NOTIFY low_rating, %L', NEW.courier_id::text);
	END IF;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER check_courier_rating
AFTER UPDATE ON courier
FOR EACH ROW
WHEN (OLD.courier_rating IS DISTINCT FROM NEW.courier_rating)
EXECUTE FUNCTION check_rating_update();
