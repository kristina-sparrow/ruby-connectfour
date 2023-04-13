# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new }

  describe '#valid_name?' do
    context 'when a name with length 0 given' do
      it 'returns false' do
        name = ''
        expect(Player).not_to be_valid_name(name)
      end
    end

    context 'when a name with length more than max length given' do
      it 'returns false' do
        name = 'qwertymanfrommarsgoingtovenus'
        expect(Player).not_to be_valid_name(name)
      end
    end

    context 'when a name with special characters given' do
      it 'returns false' do
        name = '^hello $mate!'
        expect(Player).not_to be_valid_name(name)
      end
    end

    context 'when a valid name given' do
      it 'returns true' do
        name = 'hello mate'
        expect(Player).to be_valid_name(name)
      end
    end
  end
end
