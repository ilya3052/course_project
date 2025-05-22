CREATE OR REPLACE FUNCTION rate_delivery(
	f_delivery_rating integer,
	f_order_id integer
) RETURNS void AS $$
DECLARE
	_courier_id integer;
	_courier_rating numeric;
	_count_courier_orders integer;
	_new_courier_rating numeric;
BEGIN
	IF f_delivery_rating <> 5 THEN
		UPDATE delivery SET delivery_rating = f_delivery_rating WHERE order_id = f_order_id;
	END IF;
	SELECT courier_id INTO _courier_id FROM delivery WHERE order_id = f_order_id;
	SELECT courier_rating INTO _courier_rating FROM courier WHERE courier_id = _courier_id;
	SELECT COUNT(*) INTO _count_courier_orders
	    FROM delivery d 
	    JOIN "order" o ON d.order_id = o.order_id 
    WHERE d.courier_id = _courier_id AND o.order_status = 2;
	
	_new_courier_rating := round((_count_courier_orders * _courier_rating + f_delivery_rating) / (_count_courier_orders + 1), 2);

	UPDATE courier SET courier_rating = _new_courier_rating WHERE courier_id = _courier_id;
	
END;
$$ LANGUAGE plpgsql;
