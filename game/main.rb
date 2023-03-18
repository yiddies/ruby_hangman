HANGMAN_WORDS = File.readlines("../google-10000-english-no-swears.txt")
require "json"

class HangMan
  def initialize
    @word = ""
    @guesses_left = 10
    @saved_game_path = "../saved_games"
    @savename = "saved_hangman.json"
    @hidden_word = ""
  end

  def save_game
    puts "Saving game..."
    Dir.mkdir(@saved_game_path) unless Dir.exist?(@saved_game_path)
    file_path = File.join(@saved_game_path, @savename)
    File.open(file_path, "w") do |file|
      file.write(self.to_json)
    end
  end

  def load_game
    puts "Loading game..."
    file_path = File.join(@saved_game_path, @savename)
    saved_game_data = File.read(file_path)
    saved_game = JSON.parse(saved_game_data, symbolize_names: true)
    @word = saved_game[:word]
    @guesses_left = saved_game[:guesses_left]
    @hidden_word = saved_game[:hidden_word]
    play_game
  end

  def start_game
    puts "Welcome to HangMan!"
    puts "Press 1 to start a new game"
    puts "Press 2 to load a game"
    input = gets.chomp

    if input == "1"
      @word = get_word(HANGMAN_WORDS)
      play_game
    elsif input == "2"
      load_game
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

    if @hidden_word != ""
      puts @hidden_word
      word_hidden = @hidden_word
    else
      puts word_hidden
    end

    while @guesses_left > 0 && word_hidden != @word
      puts "#{@guesses_left} Guessess left"
      puts "Guess a letter:"
      puts "Press 2 to save the game"
      guess = gets.chomp

      if guess == "2"
        @guesses_left += 1
        @hidden_word = word_hidden
        save_game
        puts "Game saved!"
      elsif guess.length > 1
        puts "Please enter only one letter"
        @guesses_left += 1
      end

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

  def to_json(*options)
    {
      word: @word,
      guesses_left: @guesses_left,
      hidden_word: @hidden_word,
    }.to_json(*options)
  end
end

HangMan.new.start_game
