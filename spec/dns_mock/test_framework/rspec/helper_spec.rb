# frozen_string_literal: true

require_relative '../../../../lib/dns_mock/test_framework/rspec/helper'

class TestClass
  include DnsMock::TestFramework::RSpec::Helper
end

RSpec.describe DnsMock::TestFramework::RSpec::Helper do
  let(:test_class_instance) { TestClass.new }

  describe '.dns_mock_server' do
    let(:dns_mock_server_instance) { instance_double('DnsMockServerInstance') }

    context 'with kwargs' do
      subject(:helper) { test_class_instance.dns_mock_server(**options) }

      let(:records) { random_records }
      let(:port) { random_port_number }
      let(:options) { { records: records, port: port } }

      it do
        expect(DnsMock::TestFramework::RSpec::Interface)
          .to receive(:start_server)
          .with(**options)
          .and_return(dns_mock_server_instance)
        expect(helper).to eq(dns_mock_server_instance)
      end
    end

    context 'without kwargs' do
      subject(:helper) { test_class_instance.dns_mock_server }

      it do
        expect(DnsMock::TestFramework::RSpec::Interface)
          .to receive(:start_server)
          .and_return(dns_mock_server_instance)
        expect(helper).to eq(dns_mock_server_instance)
      end
    end
  end
end
