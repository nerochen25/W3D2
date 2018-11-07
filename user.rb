require_relative 'question'
require_relative 'reply'
require_relative 'questionDBconnection'



class User
  attr_reader :fname, :lname
  
  def self.all
    data = QuestionDBconnection.instance.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end
  
  def self.find_by_name(fname, lname)
    raise "#{fname} not found in DB" unless fname
    # raise "#{fname} or #{lname} not found in DB" unless lname
    user = QuestionDBconnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil unless user.length > 0
    User.new(user.first)
  end
  
  def self.find_by_id(id)
    raise "#{id} not found in DB" unless id
    user = QuestionDBconnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0
    User.new(user.first)
  end
  
  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end 
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
end