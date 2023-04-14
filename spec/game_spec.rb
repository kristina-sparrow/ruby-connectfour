# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new(player1, player2, board) }
  let(:player) { class_double(Player) }
  let(:player1) { instance_double(Player) }
  let(:player2) { instance_double(Player) }
  let(:board) { instance_double(Board) }

  before do
    game.instance_variable_set(:@current_player, player1)
    game.instance_variable_set(:@other_player, player2)
  end

  describe '#update_player1_data' do
    before do
      allow(player1).to receive(:name=)
      allow(player1).to receive(:marker=)
      allow(game).to receive(:player1_name_prompt)
      allow(game).to receive(:player1_marker_prompt)
      allow(game).to receive(:create_player_name).and_return('hello')
      allow(game).to receive(:create_player_marker).and_return(':red')
    end

    it 'sends message to player 1 to update name' do
      expect(player1).to receive(:name=)
      game.update_player1_data
    end

    it 'sends message to player 1 to update marker' do
      expect(player1).to receive(:marker=)
      game.update_player1_data
    end
  end

  describe '#update_player2_data' do
    before do
      allow(player2).to receive(:name=)
      allow(player2).to receive(:marker=)
      allow(game).to receive(:player2_name_prompt)
      allow(game).to receive(:player2_marker_prompt)
      allow(game).to receive(:create_player_name).and_return('hello')
      allow(game).to receive(:create_player_marker).and_return(':red')
    end

    it 'sends message to player 1 to update name' do
      expect(player2).to receive(:name=)
      game.update_player2_data
    end

    it 'sends message to player 1 to update marker' do
      expect(player2).to receive(:marker=)
      game.update_player2_data
    end
  end

  describe '#create_player_name' do
    before do
      allow(game).to receive(:print_prompt)
    end

    context 'when the invalid name given as input' do
      context 'when invalid name given twice and a valid input given' do
        before do
          allow(game).to receive(:gets).and_return('', '', 'hell fury')
          allow(player).to receive(:valid_name?).and_return(false, false, true)
        end

        it 'shows error message twice and finishes execution' do
          expect(game).to receive(:print_invalid).with('name').twice
          game.create_player_name
        end

        it 'returns the valid name' do
          allow(game).to receive(:print_invalid)
          name = game.create_player_name
          expect(name).to eq('hell fury')
          game.create_player_name
        end
      end
    end

    context 'when a valid name given as input' do
      before do
        allow(game).to receive(:gets).and_return('hell fury')
        allow(player).to receive(:valid_name?).and_return(true)
      end

      it 'finishes execution without showing error message' do
        expect(game).not_to receive(:print_invalid).with('name')
        game.create_player_name
      end

      it 'returns the valid name' do
        allow(game).to receive(:print_invalid)
        name = game.create_player_name
        expect(name).to eq('hell fury')
        game.create_player_name
      end
    end
  end

  describe '#create_player_marker' do
    before do
      allow(game).to receive(:print_prompt)
      allow(game).to receive(:list_markers)
    end

    context 'when invalid marker given as input' do
      context 'when invalid marker given twice and a valid input given' do
        before do
          allow(game).to receive(:gets).and_return('', '', 'red')
          allow(game.instance_variable_get(:@markers)).to receive(:include?).and_return(false, false, true)
        end

        it 'shows error message twice and finishes execution' do
          expect(game).to receive(:print_invalid).with('marker').twice
          game.create_player_marker
        end

        it 'returns the valid symbol' do
          allow(game).to receive(:print_invalid)
          symbol = game.create_player_marker
          expect(symbol).to eq(:red)
          game.create_player_marker
        end
      end
    end

    context 'when a valid marker given as input' do
      before do
        allow(game).to receive(:gets).and_return('red')
        allow(game.instance_variable_get(:@markers)).to receive(:include?).and_return(true)
      end

      it 'finishes execution without showing error message' do
        expect(game).not_to receive(:print_invalid).with('marker')
        game.create_player_marker
      end

      it 'returns the valid symbol' do
        allow(game).to receive(:print_invalid)
        symbol = game.create_player_marker
        expect(symbol).to eq(:red)
        game.create_player_marker
      end
    end
  end

  describe '#move' do
    before do
      allow(game).to receive(:print_prompt)
    end

    context 'when invalid move given as input' do
      context 'when invalid move given twice and then a valid move as input' do
        before do
          allow(game).to receive(:gets).and_return('s', 'y', '6')
          allow(board).to receive(:valid_move?).and_return(false, false, true)
        end

        it 'shows error message twice and finishes execution' do
          expect(game).to receive(:print_invalid).with('move').twice
          game.move
        end

        it 'returns the valid move' do
          allow(game).to receive(:print_invalid)
          move = game.move
          expect(move).to eq(6)
        end
      end
    end

    context 'when valid move given as input' do
      before do
        allow(game).to receive(:gets).and_return('6')
        allow(board).to receive(:valid_move?).and_return(true)
      end

      it 'finishes execution without showing error message' do
        expect(game).not_to receive(:print_invalid).with('move')
        game.move
      end

      it 'returns the valid move' do
        move = game.move
        expect(move).to eq(6)
      end
    end
  end

  describe '#game_loop' do
    before do
      allow(game).to receive(:print_loop_data)
      allow(board).to receive(:print_board)
      allow(board).to receive(:add_disc)
    end

    context 'when game is over after two moves' do
      before do
        allow(game).to receive(:move).and_return(6)
        allow(board).to receive(:game_over?).and_return(false, true)
        allow(player1).to receive(:marker)
        allow(player2).to receive(:marker)
      end

      it 'sends message add_disc to board twice' do
        expect(board).to receive(:add_disc).twice
        game.game_loop
      end

      it 'sends message to switch_players once' do
        expect(game).to receive(:switch_players).once
        game.game_loop
      end
    end

    context 'when game is over after current move' do
      before do
        allow(game).to receive(:move).and_return(6)
        allow(board).to receive(:game_over?).and_return(true)
        allow(player1).to receive(:marker)
        allow(player2).to receive(:marker)
      end

      it 'sends message add_disc to board once' do
        expect(board).to receive(:add_disc).once
        game.game_loop
      end

      it 'doesnt send message to switch_players' do
        expect(game).not_to receive(:switch_players)
        game.game_loop
      end
    end
  end

  describe '#switch_players' do
    it 'switches players' do
      prev_players = [game.instance_variable_get(:@current_player), game.instance_variable_get(:@other_player)]
      game.switch_players
      new_players = [game.instance_variable_get(:@current_player), game.instance_variable_get(:@other_player)]
      expect(new_players).to eq(prev_players.reverse)
    end
  end
end
