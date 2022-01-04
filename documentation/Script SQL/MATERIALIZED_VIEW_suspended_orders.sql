CREATE VIEW `suspended_orders_view` as
    SELECT o.id, u.username, s.name, v.monthlyFee, v.numberOfMonths, o.creation, o.totalPrice
    FROM `order` o, user u, service_package s, validity_period v
    WHERE u.id = o.userId AND o.validityPeriodId = v.id AND o.servicePackageId = s.id AND o.valid = false;

# MATERIALIZED VIEW
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