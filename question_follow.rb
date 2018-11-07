require_relative 'questionDBconnection'
require_relative 'question'

class QuestionFollow
  
  def self.all
    data = QuestionDBconnection.instance.execute("SELECT * FROM question_follows")
    data.map {|datum| QuestionFollow.new(datum)}
  end
  
  def self.find_by_id(id)
    raise "#{id} not found in DB" unless id
    question = QuestionDBconnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0
    QuestionFollow.new(question.first)
  end  
  
  def self.followers_for_question_id(question_id)
    raise "#{question_id} not found in DB" unless question_id
    followers = QuestionDBconnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      JOIN
        users ON users.id = question_follows.user_id
      WHERE
        question_id = ?
    SQL
    followers.map {|follower| User.new(follower)}
  end
  
  def self.followed_questions_for_user_id(user_id)
    raise "#{user_id} not found in DB" unless user_id
    followers = QuestionDBconnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON question_follows.question_id = questions.id
      JOIN
        users ON users.id = question_follows.user_id
      WHERE
        user_id = ?
    SQL
    followers.map {|follower| Question.new(follower)}
  end
  
  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
  
end