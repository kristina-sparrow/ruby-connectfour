# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }
  let(:p1_marker) { :red }
  let(:p2_marker) { :blue }
  let(:half_board) do
    [
      ['', '', '', '', '', '', ''],
      ['', '', '', '', '', '', ''],
      ['', '', '', '', '', '', ''],
      [p1_marker, p2_marker, p1_marker, '', '', '', ''],
      [p2_marker, p1_marker, p2_marker, '', '', '', ''],
      [p1_marker, p2_marker, p2_marker, p1_marker, p2_marker, p1_marker, p2_marker]
    ]
  end
  let(:full_board) do
    [
      [p2_marker, p1_marker, p2_marker, p1_marker, p2_marker, p1_marker, p2_marker],
      [p1_marker, p2_marker, p1_marker, p2_marker, p1_marker, p1_marker, p1_marker],
      [p2_marker, p1_marker, p1_marker, p1_marker, p2_marker, p2_marker, p2_marker],
      [p2_marker, p2_marker, p2_marker, p1_marker, p1_marker, p1_marker, p2_marker],
      [p2_marker, p1_marker, p2_marker, p1_marker, p2_marker, p2_marker, p2_marker],
      [p1_marker, p2_marker, p1_marker, p2_marker, p2_marker, p1_marker, p1_marker]
    ]
  end

  describe '#game_over?' do
    context 'when win occurs' do
      it 'returns true' do
        allow(board).to receive(:win?).and_return(true)
        expect(board).to be_game_over
      end
    end

    context 'when draw occurs' do
      it 'returns true' do
        allow(board).to receive(:win?).and_return(false)
        allow(board).to receive(:draw?).and_return(true)
        expect(board).to be_game_over
      end
    end

    context 'when neither win nor draw occurs' do
      it 'returns false' do
        allow(board).to receive(:win?).and_return(false)
        allow(board).to receive(:draw?).and_return(false)
        expect(board).not_to be_game_over
      end
    end
  end

  describe '#win?' do
    context 'when a row has connected four' do
      it 'returns true' do
        allow(board).to receive(:board_empty?).and_return(false)
        allow(board).to receive(:row_has_connected_four?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when a column has connected four' do
      it 'returns true' do
        allow(board).to receive(:board_empty?).and_return(false)
        allow(board).to receive(:row_has_connected_four?).and_return(false)
        allow(board).to receive(:column_has_connected_four?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when a diagonal has connected four' do
      it 'returns true' do
        allow(board).to receive(:board_empty?).and_return(false)
        allow(board).to receive(:row_has_connected_four?).and_return(false)
        allow(board).to receive(:column_has_connected_four?).and_return(false)
        allow(board).to receive(:diagonal_has_connected_four?).and_return(true)
        expect(board).to be_win
      end
    end

    context 'when the board is empty' do
      it 'returns false' do
        allow(board).to receive(:board_empty?).and_return(true)
        expect(board).not_to be_win
      end
    end

    context 'when no connected four found' do
      it 'returns false' do
        allow(board).to receive(:row_has_connected_four?).and_return(false)
        allow(board).to receive(:column_has_connected_four?).and_return(false)
        allow(board).to receive(:diagonal_has_connected_four?).and_return(false)
        expect(board).not_to be_win
      end
    end
  end

  describe '#draw?' do
    context 'when the board is full' do
      it 'returns true' do
        allow(board).to receive(:board_full?).and_return(true)
        expect(board).to be_draw
      end
    end

    context 'when the board is empty' do
      it 'returns false' do
        allow(board).to receive(:board_full?).and_return(false)
        expect(board).not_to be_draw
      end
    end

    context 'when the board is neither empty nor full' do
      it 'returns false' do
        allow(board).to receive(:board_full?).and_return(false)
        expect(board).not_to be_draw
      end
    end
  end

  describe '#valid_move?' do
    context 'when the move is a string of length more than 1' do
      it 'returns false' do
        move = '1s'
        expect(board).not_to be_valid_move(move)
      end
    end

    context 'when the move is an out of bound value' do
      it 'returns false' do
        move = '8'
        expect(board).not_to be_valid_move(move)
      end
    end

    context 'when the move is a valid value' do
      it 'returns true' do
        move = '1'
        expect(board).to be_valid_move(move)
      end
    end

    context 'when the column is full' do
      it 'returns false' do
        move = '1'
        map = board.instance_variable_get(:@column_to_rows_mapping)
        map[0] = []
        board.instance_variable_set(:@column_to_rows_mapping, map)
        expect(board).not_to be_valid_move(move)
      end
    end
  end

  describe '#board_empty?' do
    context 'when the board is empty' do
      it 'returns true' do
        expect(board).to be_board_empty
      end
    end

    context 'when the board is full' do
      it 'returns false' do
        board.instance_variable_set(:@board, full_board)
        expect(board).not_to be_board_empty
      end
    end

    context 'when the board is neither empty nor full' do
      it 'returns false' do
        board.instance_variable_set(:@board, half_board)
        expect(board).not_to be_board_empty
      end
    end
  end

  describe '#board_full?' do
    context 'when the board is empty' do
      it 'returns false' do
        expect(board).not_to be_board_full
      end
    end

    context 'when the board is full' do
      it 'returns true' do
        board.instance_variable_set(:@board, full_board)
        expect(board).to be_board_full
      end
    end

    context 'when the board is neither empty nor full' do
      it 'returns false' do
        board.instance_variable_set(:@board, half_board)
        expect(board).not_to be_board_full
      end
    end
  end

  describe '#add_disc' do
    context 'when adding to an empty column' do
      it 'adds the disc to the column' do
        move = 1
        column = move - 1
        disc = p1_marker
        board.add_disc(move, disc)
        row = board.instance_variable_get(:@last_changed_row)
        expect(board.board[row][column]).to eq(disc)
      end
    end

    context 'when adding to a partially filled column' do
      it 'adds the disc to the column' do
        move = 7
        column = move - 1
        disc = p1_marker
        board_state = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker]
        ]
        board.instance_variable_set(:@board, board_state)
        map = board.instance_variable_get(:@column_to_rows_mapping)
        map[column] = [0, 1]
        board.instance_variable_set(:@column_to_rows_mapping, map)
        board.add_disc(move, disc)
        row = board.instance_variable_get(:@last_changed_row)
        expect(board.board[row][column]).to eq(disc)
      end
    end

    context 'when adding to an already filled column' do
      it 'column stays unchanged' do
        move = 7
        column = move - 1
        disc = p1_marker
        board_state = [
          ['', '', '', '', '', '', p2_marker],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker],
          ['', '', '', '', '', '', p1_marker]
        ]
        board.instance_variable_set(:@board, board_state)
        map = board.instance_variable_get(:@column_to_rows_mapping)
        map[column] = []
        board.instance_variable_set(:@column_to_rows_mapping, map)
        board.add_disc(move, disc)
        row = 0
        expect(board.board[row][column]).to eq(p2_marker)
      end
    end
  end

  describe '#result' do
    context 'when a win occurs' do
      it 'returns :win' do
        allow(board).to receive(:win?).and_return(true)
        expect(board.result).to eq(:win)
      end
    end

    context 'when a draw occurs' do
      it 'returns :draw' do
        allow(board).to receive(:win?).and_return(false)
        allow(board).to receive(:draw?).and_return(true)
        expect(board.result).to eq(:draw)
      end
    end

    context 'when neither win nor draw occurs' do
      it 'returns nil' do
        allow(board).to receive(:win?).and_return(false)
        allow(board).to receive(:draw?).and_return(false)
        expect(board.result).to be_nil
      end
    end
  end

  describe '#row_has_connected_four?' do
    context 'when no connected four found' do
      it 'returns false' do
        board_state = [
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          [p1_marker, '', p1_marker, p1_marker, '', '', '']
        ]
        board.instance_variable_set(:@board, board_state)
        board.instance_variable_set(:@last_changed_row, 5)
        board.instance_variable_set(:@last_changed_column, 3)
        expect(board).not_to be_row_has_connected_four
      end
    end

    context 'when no connected four found' do
      it 'returns false' do
        value = [
          [p1_marker, '', '', '', '', '', ''],
          ['', p1_marker, '', '', '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', p1_marker, '', '', ''],
          ['', '', '', '', '', '', ''],
          ['', '', '', '', '', '', '']
        ]
        board.instance_variable_set(:@board, value)
        board.instance_variable_set(:@last_changed_row, 0)
        board.instance_variable_set(:@last_changed_column, 0)
        expect(board).not_to be_diagonal_has_connected_four
      end
    end
  end
end
