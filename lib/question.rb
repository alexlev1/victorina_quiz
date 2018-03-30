class Question
  attr_reader :time, :question, :answers, :right_answer

  def initialize(time, question, answers, right_answer)
    @time = time
    @question = question
    @answers = answers
    @right_answer = right_answer
  end
end