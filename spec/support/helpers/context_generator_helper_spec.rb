# frozen_string_literal: true

RSpec.describe DnsMock::ContextGeneratorHelper, type: :helper do # rubocop:disable RSpec/FilePath
  describe '#random_dns_record_type' do
    it do
      expect(DnsMock::AVAILABLE_DNS_RECORD_TYPES).to include(random_dns_record_type)
    end
  end

  describe '#random_hostname' do
    it 'returns random hostname' do
      expect(Faker::Internet).to receive(:domain_name).and_call_original
      expect(random_hostname).to be_an_instance_of(::String)
    end
  end

  describe '#create_dns_name' do
    subject(:helper) { create_dns_name(hostname, dns_name) }

    let(:hostname) { random_hostname }
    let(:dns_name) { class_double('DnsName') }
    let(:dns_name_instance) { instance_double('DnsName') }

    it 'returns dns name instance' do
      expect(dns_name).to receive(:create).with("#{hostname}.").and_return(dns_name_instance)
      expect(helper).to eq(dns_name_instance)
    end
  end
end
