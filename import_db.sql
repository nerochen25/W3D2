PRAGMA foreign_keys = ON;

DROP TABLE if exists replies;
DROP TABLE if exists question_follows;
DROP TABLE if exists question_likes;
DROP TABLE if exists questions;
DROP TABLE if exists users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,
  
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);


CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Josh', 'Arriola'),
  ('Nero', 'Chen'),
  ('Bob', 'Doe');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Josh Question', 'JOSH JOSH JOSH', 1),
  ('Nero Question', 'NERO NERO NERO', 2),
  ('Bob Question', 'BOB BOB BOB', 3);
  
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (2, 2),
  (3, 3);
  
INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 2, 'nero-nero-nero'),
  (1, 1, 1, 'josh-josh-josh'),
  (1, 1, 3, 'bob-bob-bob' );
  
INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (2, 1),
  (3, 1),
  (1, 2),
  (3, 2);

