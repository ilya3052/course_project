CREATE OR REPLACE FUNCTION create_order(
    f_user_tgchat_id integer,
    f_order_address text
) RETURNS integer AS $$
DECLARE
    _client_id integer;
    _order_id integer;
BEGIN
    SELECT c.client_id INTO _client_id
    FROM client c 
    JOIN users u ON c.user_id = u.user_id 
    WHERE u.user_tgchat_id = f_user_tgchat_id
      AND u.user_role = 'user';

    INSERT INTO "order" (client_id, order_address)
    VALUES (_client_id, f_order_address)
    RETURNING order_id INTO _order_id;

    RETURN _order_id;
END;
$$ LANGUAGE plpgsql;
