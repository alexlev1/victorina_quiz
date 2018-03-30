class Quiz
  attr_accessor :right_answer_count, :count_question, :start_time, :end_time
  attr_reader :questions

  def self.read_from_xml(file_path)
    file = File.new(file_path)
    doc = REXML::Document.new(file)
    file.close

    questions = []

    doc.root.elements.each('question') do |q|
      time = q.attributes['minutes'].to_i
      question = q.elements['text'].text

      answers = []
      right_answer = nil

      q.elements.each('variants/variant') do |v|
        answers << v.text
        right_answer = v.text if v.attributes['right']
      end

      # Создаём вопросы
      questions << Question.new(time, question, answers.shuffle!, right_answer)
    end

    new(questions)
  end

  def initialize(questions)
    @questions = questions
    @count_question = 0
    @start_time = nil
    @end_time = nil
  end

  def current_question
    questions[count_question]
  end

  def ask_question
    current_question.question
  end

  def return_start_time
    self.start_time = Time.now.to_f
  end

  def return_end_time
    self.end_time = Time.now.to_f
  end

  def show_quiz_variants
    variants = "Варианты ответов:\n"
    current_question.answers.each_with_index do |variant, index|
      variants += "#{index += 1}. #{variant}\n"
    end
    return_start_time # Время начала вопроса
    variants
  end

  def return_right_answer
    current_question.right_answer
  end

  def timely_answer?
    (end_time - start_time).to_i >= (current_question.time * 60)
  end

  def check_right_answer(user_choice)
    current_question.answers[user_choice - 1] == return_right_answer
  end

  def check_result(user_choice)
    return_end_time # Фиксируем время ответа на вопрос

    # Проверка результата
    if timely_answer? && check_right_answer(user_choice)
      :late
    elsif check_right_answer(user_choice)
      :right
    else
      :wrong
    end
  end
end