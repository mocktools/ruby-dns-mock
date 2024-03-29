# frozen_string_literal: true

RSpec.describe DnsMock::Server::RecordsDictionaryBuilder do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:IP_ADDRESS_PATTERN) }
    it { expect(described_class).to be_const_defined(:TYPE_MAPPER) }
  end

  describe '.call' do
    subject(:records_dictionary_builder) { described_class.call(records_to_build) }

    before { stub_const('DnsMock::Server::RecordsDictionaryBuilder::TYPE_MAPPER', type_mapper) }

    describe 'Success' do
      let(:target_domain_1) { random_hostname }
      let(:target_domain_2) { random_ip_v4_address }
      let(:target_domain_3) { random_non_ascii_hostname }
      let(:record_type_1) { :record_type_1 }
      let(:record_type_2) { :record_type_2 }
      let(:record_type_3) { :record_type_3 }
      let(:record_type_4) { :record_type_4 }
      let(:target_builder_1) { class_double('TargetBuilderOne') }
      let(:target_builder_2) { class_double('TargetBuilderTwo') }
      let(:target_builder_3) { class_double('TargetBuilderThree') }
      let(:target_builder_4) { class_double('TargetBuilderFour') }
      let(:target_factory_1) { class_double('TargetFactoryOne') }
      let(:target_factory_2) { class_double('TargetFactoryTwo') }
      let(:target_factory_3) { class_double('TargetFactoryThree') }
      let(:target_factory_4) { class_double('TargetFactoryFour') }
      let(:builder_result_1) { [instance_double('TargetClassOne')] }
      let(:builder_result_2) { [instance_double('TargetClassTwo')] }
      let(:builder_result_3) { [instance_double('TargetClassThree')] * 2 }
      let(:builder_result_4) { [instance_double('TargetClassFour')] }
      let(:records_context_1) { %w[a b c] }
      let(:records_context_2) { 'record_context' }
      let(:records_context_3) { %w[d e f] }
      let(:records_context_4) { %w[x y z] }
      let(:expected_records_to_build_type_1) { records_context_1.class }
      let(:expected_records_to_build_type_2) { records_context_2.class }
      let(:expected_records_to_build_type_3) { records_context_3.class }
      let(:expected_records_to_build_type_4) { records_context_4.class }

      let(:type_mapper) do
        {
          record_type_1 => [target_builder_1, target_factory_1, expected_records_to_build_type_1],
          record_type_2 => [target_builder_2, target_factory_2, expected_records_to_build_type_2],
          record_type_3 => [target_builder_3, target_factory_3, expected_records_to_build_type_3],
          record_type_4 => [target_builder_4, target_factory_4, expected_records_to_build_type_4]
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
          },
          target_domain_3 => {
            record_type_4 => records_context_4
          }
        }
      end

      it 'returns dictionary with coerced records' do
        expect(DnsMock::Representer::Punycode).to receive(:call).twice.and_call_original
        expect(DnsMock::Representer::RdnsLookup).to receive(:call).and_call_original
        expect(target_builder_1).to receive(:call).with(target_factory_1, records_context_1).and_return(builder_result_1)
        expect(target_builder_2).to receive(:call).with(target_factory_2, records_context_2).and_return(builder_result_2)
        expect(target_builder_3).to receive(:call).with(target_factory_3, records_context_3).and_return(builder_result_3)
        expect(target_builder_4).to receive(:call).with(target_factory_4, records_context_4).and_return(builder_result_4)
        expect(records_dictionary_builder).to eq(
          {
            target_domain_1 => {
              record_type_1 => builder_result_1,
              record_type_2 => builder_result_2
            },
            "#{target_domain_2.split('.').reverse.join('.')}.in-addr.arpa" => {
              record_type_3 => builder_result_3
            },
            to_punycode_hostname(target_domain_3) => {
              record_type_4 => builder_result_4
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
