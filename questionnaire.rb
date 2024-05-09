require "pstore" # https://github.com/ruby/pstore

STORE_NAME = "tendable.pstore"
$store = PStore.new(STORE_NAME)

QUESTIONS = {
  "q1" => "Can you code in Ruby?",
  "q2" => "Can you code in JavaScript?",
  "q3" => "Can you code in Swift?",
  "q4" => "Can you code in Java?",
  "q5" => "Can you code in C#?"
}.freeze

 def do_prompt
   num_yes_answers = 0

   $store.transaction do
     QUESTIONS.each_key do |question_key|
       print QUESTIONS[question_key]
       ans = gets.chomp.downcase
       $store[question_key] = ans
       num_yes_answers += 1 if ans == 'yes' || ans == 'y'
     end
   end

   return num_yes_answers
 end

def do_report
  total_yes_answers = 0
  total_questions = QUESTIONS.size

  $store.transaction(true) do
    $store.roots.each do |question_key|
      total_yes_answers += 1 if $store[question_key] == 'yes' || $store[question_key] == 'y'
    end
  end

  current_rating = (100.0 * total_yes_answers / total_questions).round(2)
  puts "Rating for this run: #{current_rating}%"

  num_runs = $store.transaction { $store.roots.size }
  average_rating = (100.0 * total_yes_answers / (total_questions * num_runs)).round(2)
  puts "Average rating for all runs: #{average_rating}%"
end



do_prompt
do_report
