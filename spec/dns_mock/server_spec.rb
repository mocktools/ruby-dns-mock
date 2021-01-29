# frozen_string_literal: true

RSpec.describe DnsMock::Server do
  after { stop_all_running_servers }

  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:WARMUP_DELAY) }
    it { expect(described_class).to be_const_defined(:PACKET_MAX_BYTES_SIZE) }
  end

  describe '.new' do
    subject(:server_instance) do
      described_class.new(
        socket_instance,
        records_dictionary_builder_service,
        random_available_port_service,
        **kwargs
      )
    end

    let(:socket_instance) { ::UDPSocket.new }
    let(:records_dictionary_builder_service) { DnsMock::Server::RecordsDictionaryBuilder }
    let(:random_available_port_service) { DnsMock::Server::RandomAvailablePort }

    describe 'Success' do
      context 'without keyword args' do
        let(:records_dictionary_builder_service) { instance_double('CallableObject') }
        let(:kwargs) { {} }

        it 'creates UDP DNS mock server without records binded on random port' do
          expect(records_dictionary_builder_service).to receive(:call).with({}).and_return({})
          expect(random_available_port_service).to receive(:call).and_call_original
          expect(server_instance.without_mocks?).to be(true)
          expect(server_instance.alive?).to be(true)
          expect(server_instance.send(:exception_if_not_found)).to be(false)
        end
      end

      context 'with keyword args' do
        let(:records) { random_records }
        let(:port) { 5300 }
        let(:kwargs) { { records: records, port: port, exception_if_not_found: true } }

        it 'creates UDP DNS mock server with records binded on passed port' do
          expect(records_dictionary_builder_service).to receive(:call).with(records).and_call_original
          expect(random_available_port_service).not_to receive(:call)
          expect(server_instance.port).to eq(port)
          expect(server_instance.without_mocks?).to be(false)
          expect(server_instance.alive?).to be(true)
          expect(server_instance.send(:exception_if_not_found)).to be(true)
        end
      end
    end

    describe 'Failure' do
      context 'when passed port is busy' do
        let(:port) { 42_999 }
        let(:kwargs) { { port: port } }

        before { udp_service(port).bind! }

        after { udp_service.unbind! }

        it do
          expect { server_instance }
            .to raise_error(
              DnsMock::Error::PortInUse,
              "Impossible to bind UDP DNS mock server on #{DnsMock::Server::CURRENT_HOST_NAME}:#{port}. Address already in use"
            )
        end
      end

      context 'when exception strategy for not found record enabled' do
        let(:kwargs) { { exception_if_not_found: true } }

        before { server_instance }

        it do
          expect(random_hostname).not_to have_dns
            .with_type('A')
            .and_address(random_ip_v4_address)
            .config(nameserver: 'localhost', port: server_instance.port)
          expect(server_instance.alive?).to be(false)
        end
      end
    end
  end

  describe '#port' do
    subject(:port) { described_class.new.port }

    it { is_expected.to be_an_instance_of(::Integer) }
  end

  describe '#assign_mocks' do
    subject(:assign_mocks) { server_instance.assign_mocks(new_records) }

    let(:server_instance) { described_class.new(records: records) }
    let(:new_records) { random_records }

    context 'when records are empty' do
      let(:records) { {} }

      it 'reassigns server dns mocks, returns true' do
        expect { assign_mocks }
          .to change { server_instance.send(:records) }
          .from(records)
          .to(create_records_dictionary_by_records(new_records))
        expect(assign_mocks).to be(true)
      end
    end

    context 'when records are not empty' do
      let(:records) { random_records }

      it { is_expected.to be_nil }
    end
  end

  describe '#reset_mocks!' do
    subject(:reset_mocks) { server_instance.reset_mocks! }

    let(:server_instance) { described_class.new(records: records) }

    context 'when records are empty' do
      let(:records) { {} }

      it 'erases current server dns mocks, returns true' do
        expect(reset_mocks).to be(true)
      end
    end

    context 'when records are not empty' do
      let(:records) { random_records }

      it 'erases current server dns mocks, returns true' do
        expect { reset_mocks }
          .to change { server_instance.send(:records) }
          .from(create_records_dictionary_by_records(records))
          .to({})
        expect(reset_mocks).to be(true)
      end
    end
  end

  describe '#without_mocks?' do
    subject(:without_mocks) { server_instance.without_mocks? }

    let(:server_instance) { described_class.new(records: records) }

    context 'when records are empty' do
      let(:records) { {} }

      it { is_expected.to be(true) }
    end

    context 'when records are not empty' do
      let(:records) { random_records }

      it { is_expected.to be(false) }
    end
  end

  describe '#alive?' do
    subject(:alive) { server_instance.alive? }

    let(:server_instance) { described_class.new }

    context 'when server thread is alive' do
      it { is_expected.to be(true) }
    end

    context 'when server thread is dead' do
      it do
        server_instance.stop!
        sleep(0.001)
        expect(alive).to be(false)
      end
    end
  end

  describe '#stop!' do
    subject(:stop) { server_instance.stop! }

    let(:server_instance) { described_class.new }

    context 'when server thread is alive' do
      it { is_expected.to be(true) }
    end

    context 'when server thread is dead' do
      it do
        server_instance.stop!
        sleep(0.001)
        expect(stop).to be(true)
      end
    end
  end
end
