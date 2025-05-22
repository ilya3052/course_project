CREATE OR REPLACE FUNCTION cancel_order(
	f_order_od integer
) RETURNS integer AS $$
BEGIN
	SELECT 1 FROM "order" WHERE order_id = f_order_id FOR UPDATE NOWAIT;
	IF FOUND THEN
		DELETE FROM "order" WHERE order_id = f_order_id;
		RETURN 0;
	ELSE
		RETURN 1;
	END IF;
END
$$ LANGUAGE plpgsql;
