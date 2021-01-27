# frozen_string_literal: true

RSpec.describe DnsMock::Server::RecordsDictionaryBuilder do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:IP_ADDRESS_PATTERN) }
    it { expect(described_class).to be_const_defined(:IP_OCTET_GROUPS) }
    it { expect(described_class).to be_const_defined(:RDNS_LOOKUP_REPRESENTATION) }
    it { expect(described_class).to be_const_defined(:TYPE_MAPPER) }
  end

  describe '.call' do
    subject(:records_dictionary_builder) { described_class.call(records_to_build) }

    before { stub_const('DnsMock::Server::RecordsDictionaryBuilder::TYPE_MAPPER', type_mapper) }

    describe 'Success' do
      let(:target_domain_1) { random_hostname }
      let(:target_domain_2) { random_ip_v4_address }
      let(:record_type_1) { :record_type_1 }
      let(:record_type_2) { :record_type_2 }
      let(:record_type_3) { :record_type_3 }
      let(:target_builder_1) { class_double('TargetBuilderOne') }
      let(:target_builder_2) { class_double('TargetBuilderTwo') }
      let(:target_builder_3) { class_double('TargetBuilderThree') }
      let(:target_factory_1) { class_double('TargetFactoryOne') }
      let(:target_factory_2) { class_double('TargetFactoryTwo') }
      let(:target_factory_3) { class_double('TargetFactoryThree') }
      let(:builder_result_1) { [instance_double('TargetClassOne')] }
      let(:builder_result_2) { [instance_double('TargetClassTwo')] }
      let(:builder_result_3) { [instance_double('TargetClassThree')] * 2 }
      let(:records_context_1) { %w[a b c] }
      let(:records_context_2) { 'record_context' }
      let(:records_context_3) { %w[d e f] }
      let(:expected_records_to_build_type_1) { records_context_1.class }
      let(:expected_records_to_build_type_2) { records_context_2.class }
      let(:expected_records_to_build_type_3) { records_context_3.class }

      let(:type_mapper) do
        {
          record_type_1 => [target_builder_1, target_factory_1, expected_records_to_build_type_1],
          record_type_2 => [target_builder_2, target_factory_2, expected_records_to_build_type_2],
          record_type_3 => [target_builder_3, target_factory_3, expected_records_to_build_type_3]
        }
      end

      let(:records_to_build) do
        {
          target_domain_1 => {
            record_type_1 => records_context_1,
            record_type_2 => records_context_2
          },
          target_domain_2 => {
            record_type_3 => records_context_3
          }
        }
      end

      it 'returns dictionary with coerced records' do
        expect(target_builder_1).to receive(:call).with(target_factory_1, records_context_1).and_return(builder_result_1)
        expect(target_builder_2).to receive(:call).with(target_factory_2, records_context_2).and_return(builder_result_2)
        expect(target_builder_3).to receive(:call).with(target_factory_3, records_context_3).and_return(builder_result_3)
        expect(records_dictionary_builder).to eq(
          {
            target_domain_1 => {
              record_type_1 => builder_result_1,
              record_type_2 => builder_result_2
            },
            "#{target_domain_2.split('.').reverse.join('.')}.in-addr.arpa" => {
              record_type_3 => builder_result_3
            }
          }
        )
      end
    end

    describe 'Failure' do
      let(:record_type) { :record_type }
      let(:current_records_context_to_build) { 'record_context' }
      let(:expected_records_to_build_type) { ::Array }
      let(:type_mapper) { { record_type => ['target_builder', 'target_factory', expected_records_to_build_type] } }
      let(:target_domain) { random_hostname }

      context 'when invalid records to build type passed' do
        let(:records_to_build) { 42 }

        it do
          expect { records_dictionary_builder }
            .to raise_error(DnsMock::Error::ArgumentType, "Argument class is a #{records_to_build.class}. Should be a Hash")
        end
      end

      context 'when invalid record host key passed' do
        let(:record_hostname) { :'some_domain.com' }
        let(:records_to_build) { { record_hostname => {} } }

        it do
          expect { records_dictionary_builder }
            .to raise_error(
              DnsMock::Error::RecordHostType,
              "Hostname #{record_hostname} type is #{record_hostname.class}. Should be a String"
            )
        end
      end

      context 'when invalid record type is defined' do
        let(:another_record_type) { :"another_#{record_type}" }
        let(:records_to_build) { { target_domain => { another_record_type => current_records_context_to_build } } }

        it do
          expect { records_dictionary_builder }
            .to raise_error(DnsMock::Error::RecordType, "#{another_record_type} is invalid record type")
        end
      end

      context 'when invalid record context type defined' do
        let(:records_to_build) { { target_domain => { record_type => current_records_context_to_build } } }

        it do
          expect { records_dictionary_builder }
            .to raise_error(
              DnsMock::Error::RecordContextType,
              "#{current_records_context_to_build.class} is invalid " \
              "record context type for #{record_type.upcase} record. " \
              "Should be a #{expected_records_to_build_type}"
            )
        end
      end
    end
  end
end
