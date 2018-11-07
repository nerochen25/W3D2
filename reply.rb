require_relative 'questionDBconnection'
require_relative 'user'


class Reply
  
  def self.all
    data = QuestionDBconnection.instance.execute("SELECT * FROM replies")
    data.map {|datum| Reply.new(datum)}
  end
  
  def self.find_by_user_id(user_id)
    raise "#{user_id} not in database" unless user_id
    reply = QuestionDBconnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil unless reply.length > 0
    reply.map {|reply| Reply.new(reply)}
  end
  
  def self.find_by_question_id(question_id)
    raise "#{question_id} not in database" unless question_id
    reply = QuestionDBconnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil unless reply.length > 0
    reply.map {|reply| Reply.new(reply)}
  end
  
  def self.find_by_id(id)
    raise "#{id} not found in DB" unless id
    reply = QuestionDBconnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0
    Reply.new(reply.first)
  end  
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_replies
    raise "#{@id} not found in DB" unless @id
    reply = QuestionDBconnection.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    return nil unless reply.length > 0
    reply.map { |reply| Reply.new(reply) }
  end
end
