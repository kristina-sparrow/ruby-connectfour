# frozen_string_literal: true

require_relative './display'

class Board
  include Display

  attr_reader :board

  def initialize
    @rows = 6
    @columns = 7
    @board = Array.new(@rows) { Array.new(@columns, '') }
    @last_changed_column = nil
    @last_changed_row = nil
    @column_to_rows_mapping = Hash.new { |hash, key| hash[key] = (0..(@rows - 1)).to_a }
  end

  def add_disc(move, disc)
    column = move - 1
    return if @column_to_rows_mapping[column].empty?
    @last_changed_row = @column_to_rows_mapping[column].pop
    @last_changed_column = column
    board[@last_changed_row][column] = disc
  end

  def valid_move?(move)
    move.match?(/^[1-7]{1}$/) && !@column_to_rows_mapping[move.to_i - 1].empty?
  end

  def game_over?
    win? || draw?
  end

  def win?
    return false if board_empty?
    row_has_connected_four? || column_has_connected_four? || diagonal_has_connected_four?
  end

  def draw?
    board_full?
  end

  def row_has_connected_four?
    connected_four?(@columns, @board[@last_changed_row])
  end

  def column_has_connected_four?
    connected_four?(@rows, @board.transpose[@last_changed_column])
  end

  def diagonal_has_connected_four?
    right_diagonal_has_connected_four? || left_diagonal_has_connected_four?
  end

  def board_empty?
    board.flatten.all?(&:empty?)
  end

  def board_full?
    board.flatten.none?(&:empty?)
  end

  def result
    return :win if win?
    return :draw if draw?
  end

  private

  def connected_four?(iterations, array)
    last_marker = @board[@last_changed_row][@last_changed_column]
    (iterations - 3).times do |index|
      return true if array[index..(index + 3)].all? { |value| value == last_marker }
    end
    false
  end

  def right_diagonal_has_connected_four?
    right_diagonal = create_right_diagonal
    connected_four?(right_diagonal.size, right_diagonal)
  end

  def left_diagonal_has_connected_four?
    left_diagonal = create_left_diagonal
    connected_four?(left_diagonal.size, left_diagonal)
  end

  def create_right_diagonal
    create_diagonal([[-1, -1], [-2, -2], [-3, -3]])
  end

  def create_left_diagonal
    create_diagonal([[-1, 1], [-2, 2], [-3, 3]])
  end

  def create_diagonal(changes)
    first_half = []
    second_half = []
    i = @last_changed_row
    j = @last_changed_column
    middle_element = [@board[i][j]]
    changes.each do |x, y|
      update_first_half(first_half, i + x, j + y)
      update_second_half(second_half, i - x, j - y)
    end
    first_half.reverse + middle_element + second_half
  end

  def update_first_half(first_half, row, column)
    return unless boundary_satisifed?(row, column)
    first_half << @board[row][column]
  end

  def update_second_half(second_half, row, column)
    return unless boundary_satisifed?(row, column)
    second_half << @board[row][column]
  end

  def boundary_satisifed?(row, column)
    (row < @rows && row >= 0) && (column < @columns && column >= 0)
  end
end
