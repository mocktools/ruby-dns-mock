# frozen_string_literal: true

RSpec.describe DnsMock::ServerHelper, type: :helper do # rubocop:disable RSpec/FilePath
  describe '#start_random_server' do
    let(:server_instance) { instance_double('DnsMockServer') }

    context 'without total option' do
      it 'returns random running dns mock server' do
        expect(DnsMock).to receive(:start_server).and_return(server_instance)
        expect(start_random_server).to eq(server_instance)
      end
    end

    context 'with total option' do
      let(:total) { rand(2..10) }

      it 'returns array with predefined count of server instances' do
        expect(DnsMock).to receive(:start_server).at_least(total).and_return(server_instance)
        expect(start_random_server(total: total)).to eq(::Array.new(total) { server_instance })
      end
    end
  end

  describe '#stop_all_running_servers' do
    it 'kills all running dns mock servers' do
      expect(DnsMock).to receive(:stop_running_servers!)
      stop_all_running_servers
    end
  end
end
