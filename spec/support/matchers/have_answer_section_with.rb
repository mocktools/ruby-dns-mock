# frozen_string_literal: true

RSpec::Matchers.define(:have_answer_section_with) do |hostname, records_by_record_type|
  match do |binary_dns_message|
    hostname = ::Resolv::DNS::Name.create("#{hostname}.")
    ::Resolv::DNS::Message
      .decode(binary_dns_message)
      .answer
      .zip(records_by_record_type)
      .all? do |answer_section_item, dictionary_record|
      answer_section_item.eql?([hostname, DnsMock::Response::Answer::TTL, dictionary_record])
    end
  end
end
