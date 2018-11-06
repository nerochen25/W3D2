require "sqlite3"
require 'singleton'

class QuestionDBconnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_reader :fname, :lname
  
  def self.all
    data = QuestionDBconnection.instance.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end
  
  def self.find_by_name(fname)
    raise "#{fname} not found in DB" unless fname
    user = QuestionDBconnection.instance.execute(<<-SQL, fname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?
    SQL
    return nil unless user.length > 0
    User.new(user.first)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end 
  
end

class Question
  def self.find_by_author_id(author_id)
    raise "#{author_id} not in database" unless author_id
    question = QuestionDBconnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    return nil unless question.length > 0
    question.map {|question| Question.new(question)}
  end
    
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
end