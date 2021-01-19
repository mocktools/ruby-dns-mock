# frozen_string_literal: true

module DnsMock
  RSpec.shared_examples 'random free upd & tcp port' do
    it 'returns random free upd & tcp port' do
      expect(random_available_port).to eq(free_port_number)
    end
  end
end
