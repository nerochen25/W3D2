require_relative 'questionDBconnection'

class Reply
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
  
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
end
