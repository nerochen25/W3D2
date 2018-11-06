require_relative 'questionDBconnection'


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