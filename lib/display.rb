# frozen_string_literal: true

require_relative './color'

module Display
  include Color

  def circles_map(symbol)
    {
      red: "\u{1f534}",
      blue: "\u{1f535}",
      green: "\u{1f7e2}",
      yellow: "\u{1f7e1}",
      white: "\u{26aa}"
    }[symbol]
  end

  def print_banner
    puts <<~INTRO

      [0;1;35;95m┌─[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m─┐[0m
      [0;1;31;91m│░[0;1;33;93m█▀[0;1;32;92m▀░[0;1;36;96m█▀[0;1;34;94m█░[0;1;35;95m█▀[0;1;31;91m█░[0;1;33;93m█▀[0;1;32;92m█░[0;1;36;96m█▀[0;1;34;94m▀░[0;1;35;95m█▀[0;1;31;91m▀░[0;1;33;93m▀█[0;1;32;92m▀░[0;1;36;96m░░[0;1;34;94m░░[0;1;35;95m█▀[0;1;31;91m▀░[0;1;33;93m█▀[0;1;32;92m█░[0;1;36;96m█░[0;1;34;94m█░[0;1;35;95m█▀[0;1;31;91m▄│[0m
      [0;1;33;93m│░[0;1;32;92m█░[0;1;36;96m░░[0;1;34;94m█░[0;1;35;95m█░[0;1;31;91m█░[0;1;33;93m█░[0;1;32;92m█░[0;1;36;96m█░[0;1;34;94m█▀[0;1;35;95m▀░[0;1;31;91m█░[0;1;33;93m░░[0;1;32;92m░█[0;1;36;96m░░[0;1;34;94m▄▄[0;1;35;95m▄░[0;1;31;91m█▀[0;1;33;93m▀░[0;1;32;92m█░[0;1;36;96m█░[0;1;34;94m█░[0;1;35;95m█░[0;1;31;91m█▀[0;1;33;93m▄│[0m
      [0;1;32;92m│░[0;1;36;96m▀▀[0;1;34;94m▀░[0;1;35;95m▀▀[0;1;31;91m▀░[0;1;33;93m▀░[0;1;32;92m▀░[0;1;36;96m▀░[0;1;34;94m▀░[0;1;35;95m▀▀[0;1;31;91m▀░[0;1;33;93m▀▀[0;1;32;92m▀░[0;1;36;96m░▀[0;1;34;94m░░[0;1;35;95m░░[0;1;31;91m░░[0;1;33;93m▀░[0;1;32;92m░░[0;1;36;96m▀▀[0;1;34;94m▀░[0;1;35;95m▀▀[0;1;31;91m▀░[0;1;33;93m▀░[0;1;32;92m▀│[0m
      [0;1;36;96m└─[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m──[0;1;34;94m──[0;1;35;95m──[0;1;31;91m──[0;1;33;93m──[0;1;32;92m──[0;1;36;96m─┘[0m

    INTRO
  end

  def print_rules
    puts <<~RULES
    * Two player game
    * Choose a column to put a disc
    * If a player gets a disc connected four, they win
    * Connected four can be in rows, columns or diagonals
    * If all columns get filled, then the game is a draw

    RULES
  end

  def player1_name_prompt
    puts "Enter player 1 name (Max length: 15)"
    print_prompt
  end

  def player2_name_prompt
    puts "Enter player 2 name (Max length: 15)"
    print_prompt
  end

  def list_markers
    puts <<~MARKERS
      #{@markers.map(&:to_sym).map { |color| color_text(color.to_s.capitalize, color) }.join(' ')}
    MARKERS
    print_prompt
  end

  def player1_marker_prompt
    puts "Select player1 marker (Enter one option):"
  end
  
  def player2_marker_prompt
    puts "Select player2 marker (Enter one option):"
  end

  def print_column_number_prompt
    puts "\nEnter a Column number (1-7)"
    print_prompt
  end

  def print_prompt
    print "\e[0;1;34;94m: \e[0m"
  end

  def print_current_player_data
    puts <<~PLAYER
      #{color_text(@current_player.name, :green)}(#{color_text(@current_player.marker.capitalize, @current_player.marker.to_sym)})'s move

    PLAYER
  end

  def print_board
    @board.each do |row|
      printable_row = row.map do |element|
        element = 'white' if element.empty?
        circles_map(element.to_sym)
      end
      print <<~ROW
        #{printable_row.join(' ')}
      ROW
    end
  end

  def print_invalid(string)
    puts color_text("Invalid #{string.capitalize}!\n", :red)
  end

  def print_loop_data
    clear_screen
    print_banner
    print_current_player_data
    @board.print_board
    print_column_number_prompt
  end

  def print_thanks
    puts <<~THANKS

      [0;1;35;95mTh[0;1;31;91man[0;1;33;93mks[0m [0;1;32;92mf[0;1;36;96mor[0m [0;1;34;94mp[0;1;35;95mla[0;1;31;91myi[0;1;33;93mng[0m [0;1;32;92m:[0;1;36;96m)[0m

    THANKS
  end

  def announce_winner(player)
    puts <<~WINNER
      #{color_text(player.name.to_s, :green)} #{color_text("(#{player.marker})", player.marker)} #{color_text('Won!', :green)}
    WINNER
  end

  def announce_draw
    puts <<~DRAW
      #{color_text("It's a Draw!", :yellow)}
    DRAW
  end

  def prepare_screen_for_result
    clear_screen
    print_banner
    @board.print_board
  end

  def clear_screen
    system('clear')
  end
end
