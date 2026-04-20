USE sakila;

DROP TABLE IF EXISTS transaction_;
DROP TABLE IF EXISTS account;

CREATE TABLE account (
  account_id INT UNSIGNED PRIMARY KEY,
  avail_balance DECIMAL(10,2) NOT NULL,
  last_activity_date DATETIME NOT NULL
);

CREATE TABLE transaction_ (
  txn_id INT UNSIGNED PRIMARY KEY,
  txn_date DATE NOT NULL,
  account_id INT UNSIGNED NOT NULL,
  txn_type_cd CHAR(1) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (account_id) REFERENCES account(account_id)
);

INSERT INTO account (account_id, avail_balance, last_activity_date) VALUES
  (123, 500.00, '2019-07-10 20:53:27'),
  (789,  75.00, '2019-06-22 15:18:35');

INSERT INTO transaction_ (txn_id, txn_date, account_id, txn_type_cd, amount) VALUES
  (1001, '2019-05-15', 123, 'C', 500.00),
  (1002, '2019-06-01', 789, 'C',  75.00);
