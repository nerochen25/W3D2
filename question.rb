require_relative 'questionDBconnection'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follow'

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
    
  def self.find_by_id(id)
    raise "#{id} not found in DB" unless id
    question = QuestionDBconnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0
    Question.new(question.first)
  end  
    
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollow.followers_for_question_id(@id)
  end
  
end