-- if has not given name for the constraint

ALTER TABLE minions_info

ADD CONSTRAINT UQ_email_and_id UNIQUE (id, email),

ADD CONSTRAINT CK_banana_is_positive CHECK (banana > 0);


-- and as per the task
ALTER TABLE minions_info
ADD CONSTRAINT unique_containt UNIQUE (id, email),
ADD CONSTRAINT banana_check CHECK (banana > 0);