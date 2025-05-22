CREATE OR REPLACE FUNCTION confirm_receipt(
	f_order_id integer
) RETURNS integer AS $$
DECLARE
	_courier_id integer;
BEGIN
	SELECT c.courier_id INTO _courier_id 
		FROM courier c 
		JOIN delivery d ON d.courier_id = c.courier_id 
	WHERE d.order_id = f_order_id;

	IF FOUND THEN
		UPDATE "order" SET order_status = 2 WHERE order_id = f_order_id;
		UPDATE courier SET courier_is_busy_with_order = false WHERE courier_id = _courier_id;	
		RETURN 0;
	ELSE
		RETURN 1;
	END IF;
END
$$ LANGUAGE plpgsql;
