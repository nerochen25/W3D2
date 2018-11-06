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
  ('Josh', 'Arriola');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Josh Question', 'JOSH JOSH JOSH', (SELECT id FROM users WHERE fname = 'Josh'));
  
INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Josh'), (SELECT id FROM questions WHERE title = 'Josh Question'));
  
INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Josh Question'), NULL, (SELECT id FROM users WHERE fname = 'Josh'), 'JOSH JOSH JOSH');