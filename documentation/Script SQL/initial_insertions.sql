
# SERVICE INSERTIONS
INSERT INTO service (type, numberOfSms, numberOfMinutes, extraMinutesFee, extraSmsFee, numberOfGb, extraGbFee)
VALUES
       ('FIXED_PHONE', null, null, null, null, null, null),
       ('MOBILE_PHONE', 1000, 1000, 0.10, 0.20, null, null),
       ('MOBILE_PHONE', 1000, 2000, 0.05, 0.20, null, null),
       ('FIXED_INTERNET', null, null, null, null, 500, 3),
       ('FIXED_INTERNET', null, null, null, null, 1000, 1.5),
       ('MOBILE_INTERNET', null, null, null, null, 20 , 1),
       ('MOBILE_INTERNET', null, null, null, null, 50 , 0.5);

# VALIDITY PERIOD INSERTIONS
INSERT INTO validity_period (numberofmonths, monthlyfee)
VALUES
       (12, 20),
       (24, 18),
       (36, 15),
       (12, 30),
       (24, 28),
       (36, 25);

# EMPLOYEE REGISTRATION INSERTIONS
INSERT INTO employee (username, password)
VALUES
        ('giulia', 'giulia'),
        ('ale', 'ale');
