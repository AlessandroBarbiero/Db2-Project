CREATE TABLE suspended_orders (
                         `id` int NOT NULL
);

DELIMITER $$

CREATE TRIGGER add_suspended_order
    AFTER INSERT ON `order`
    FOR EACH ROW
begin
    IF  new.valid = false
    THEN
        INSERT INTO suspended_orders
            value (new.id);

    END IF;
end;
$$

CREATE TRIGGER remove_suspended_order
    AFTER UPDATE ON `order`
    FOR EACH ROW
begin
    IF  old.valid = false AND
        new.valid = true
    THEN
        DELETE FROM suspended_orders
        WHERE suspended_orders.id = new.id;
    END IF;
END
$$

DELIMITER ;