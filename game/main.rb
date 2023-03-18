HANGMAN_WORDS = File.readlines("../google-10000-english-no-swears.txt")

class HangMan
  def initialize
    @word = ""
    @guesses_left = 10
  end

  def start_game
    puts "Welcome to HangMan!"
    puts "Press 1 to start a new game"
    puts "Press 2 to load a game"
    input = gets.chomp

    if input == "1"
      @word = get_word(HANGMAN_WORDS)
      return play_game
    elsif input == "2"
      puts "test"
    end
  end

  def get_word(hangman_words)
    random_word = hangman_words.sample.chomp
    if random_word.length >= 5
      @word = random_word
    else
      return get_word(hangman_words)
    end
  end

  def play_game
    puts @word
    word_hidden = "_" * @word.length
    puts word_hidden
    while @guesses_left > 0 && word_hidden != @word
      puts "#{@guesses_left} Guessess left"
      puts "Guess a letter:"
      guess = gets.chomp
      @word.each_char.with_index do |char, i|
        if char == guess
          word_hidden[i] = guess
        end
      end
      if word_hidden == @word
        puts "Correct!"
      else
        @guesses_left -= 1
      end
      puts word_hidden
    end
    if @guesses_left == 0
      puts "Game Over!"
      puts "The word was #{@word}"
    end
  end
end

HangMan.new.start_game
