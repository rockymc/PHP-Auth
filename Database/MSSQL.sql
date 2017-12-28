--drop table pauth_users
--drop table pauth_users_confirmations
--drop table pauth_users_remembered
--drop table pauth_users_resets
--drop table pauth_users_throttling

CREATE TABLE pauth_users (
  [id] int check ([id] > 0) NOT NULL IDENTITY,
  [email] varchar(249) NOT NULL,
  [password] varchar(255) NOT NULL,
  [username] varchar(100) DEFAULT NULL,
  [status] smallint check ([status] >= 0) NOT NULL DEFAULT '0',
  [verified] smallint check ([verified] >= 0) NOT NULL DEFAULT '0',
  [resettable] smallint check ([resettable] >= 0) NOT NULL DEFAULT '1',
  [roles_mask] int check ([roles_mask] >= 0) NOT NULL DEFAULT '0',
  [registered] int check ([registered] > 0) NOT NULL,
  [last_login] int check ([last_login] > 0) DEFAULT NULL,
  PRIMARY KEY ([id]),
  CONSTRAINT [pauth_users_email] UNIQUE  ([email])
)  ;

CREATE TABLE pauth_users_confirmations (
  [id] int check ([id] > 0) NOT NULL IDENTITY,
  [user_id] int check ([user_id] > 0) NOT NULL,
  [email] varchar(249) NOT NULL,
  [selector] varchar(16) NOT NULL,
  [token] varchar(255) NOT NULL,
  [expires] int check ([expires] > 0) NOT NULL,
  PRIMARY KEY ([id]),
  CONSTRAINT [pauth_users_confirmations_selector] UNIQUE  ([selector])
)  ;

CREATE INDEX [email_expires] ON pauth_users_confirmations ([email],[expires]);
CREATE INDEX [user_id] ON pauth_users_confirmations ([user_id]);

CREATE TABLE pauth_users_remembered (
  [id] bigint check ([id] > 0) NOT NULL IDENTITY,
  [user] int check ([user] > 0) NOT NULL,
  [selector] varchar(24) NOT NULL,
  [token] varchar(255) NOT NULL,
  [expires] int check ([expires] > 0) NOT NULL,
  PRIMARY KEY ([id]),
  CONSTRAINT [pauth_users_remembered_selector] UNIQUE  ([selector])
)  ;

CREATE INDEX [user] ON pauth_users_remembered ([user]);

CREATE TABLE pauth_users_resets (
  [id] bigint check ([id] > 0) NOT NULL IDENTITY,
  [user] int check ([user] > 0) NOT NULL,
  [selector] varchar(20) NOT NULL,
  [token] varchar(255) NOT NULL,
  [expires] int check ([expires] > 0) NOT NULL,
  PRIMARY KEY ([id]),
  CONSTRAINT [pauth_users_resets_selector] UNIQUE  ([selector])
)  ;

CREATE INDEX [user_expires] ON pauth_users_resets ([user],[expires]);

CREATE TABLE pauth_users_throttling (
  [bucket] varchar(44) NOT NULL,
  [tokens] float check ([tokens] > 0) NOT NULL,
  [replenished_at] int check ([replenished_at] > 0) NOT NULL,
  [expires_at] int check ([expires_at] > 0) NOT NULL,
  PRIMARY KEY ([bucket])
)  ;

CREATE INDEX [expires_at] ON pauth_users_throttling ([expires_at]);
