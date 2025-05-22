CREATE OR REPLACE FUNCTION accept_order(
	f_user_tgchat_id integer,
	f_order_id integer
) RETURNS integer AS $$
DECLARE
	_courier_id integer;
	_order_status integer;
BEGIN

	SELECT c.courier_id INTO _courier_id
		FROM courier c 
		JOIN users u ON c.user_id = u.user_id 
	WHERE u.user_tgchat_id = f_user_tgchat_id AND u.user_role = 'courier';

	SELECT order_status INTO _order_status FROM "order" WHERE order_id = f_order_id FOR UPDATE NOWAIT;

	IF NOT FOUND OR _order_status <> 0 THEN
		RETURN 1;
	ELSE
		INSERT INTO delivery (courier_id, order_id) VALUES (_courier_id, f_order_id);
		UPDATE courier SET courier_is_busy_with_order = true WHERE courier_id = _courier_id;
		UPDATE "order" SET order_status = 1 WHERE order_id = f_order_id;
		RETURN 0;
	END IF;

END
$$ LANGUAGE plpgsql;
