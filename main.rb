require "rexml/document"
require_relative "lib/question"
require_relative "lib/quiz"

current_path = File.dirname(__FILE__)
file_path = current_path + "/data/questions.xml"
abort "Извините, файл c вопросами для викторины не найден" unless File.exist?(file_path)

# Создаём тест из XML файла
quiz = Quiz.read_from_xml(file_path)

# Тест
puts "Мини-викторина. Ответьте на вопросы."

# Проходим по вопросам
right_answer_count = 0

while quiz.count_question < quiz.questions.length
  # Задаём вопрос
  puts quiz.ask_question

  # Варианты ответа
  puts quiz.show_quiz_variants

  # Пользователь отвечает на вопрос
  user_choice = STDIN.gets.to_i

  result = quiz.check_result(user_choice)

  case result
    when :late
      puts "Верно, но поздно... Не засчитываем"
    when :right
      right_answer_count += 1
      puts "Верно!"
    when :wrong
      puts "Неверно. Правильный ответ: #{quiz.return_right_answer}"
  end
  quiz.count_question += 1
end

# Выводим результат
puts "Количество правильных ответов: #{right_answer_count} из #{quiz.questions.length}"