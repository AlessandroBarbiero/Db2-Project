CREATE VIEW `insolvent_users_view` as
SELECT distinct u.username, u.email
FROM `order` o, user u
WHERE u.id = o.userId AND o.valid = false;

# MATERIALIZED VIEW
CREATE TABLE `insolvent_users` (
                                   `id` int NOT NULL UNIQUE,
                                   `username` varchar(255) NOT NULL UNIQUE,
                                   `email` varchar(255) NOT NULL UNIQUE
);

DELIMITER $$

CREATE TRIGGER add_insolvent_user
    AFTER INSERT ON `order`
    FOR EACH ROW
begin
    IF
        new.valid = false AND
        NOT EXISTS(
            SELECT *
            FROM insolvent_users
            WHERE id=new.userId
            )
    THEN
        INSERT INTO insolvent_users
            (SELECT u.id, u.username, u.email
             FROM user u
             WHERE u.id = new.userId);

    END IF;
end;
$$

CREATE TRIGGER remove_insolvent_user
    AFTER UPDATE ON `order`
    FOR EACH ROW
begin
    IF  old.valid = false AND
        new.valid = true AND
        NOT EXISTS(
            SELECT *
            FROM `order` o
            WHERE o.valid = false AND
                     new.userId = o.userId
            )
    THEN
        DELETE FROM insolvent_users
            WHERE insolvent_users.id = new.userId;
    END IF;
END
$$

DELIMITER ;