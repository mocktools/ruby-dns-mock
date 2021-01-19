# frozen_string_literal: true

RSpec::Matchers.define(:have_question_section_with) do |hostname, record_type|
  match do |binary_dns_message|
    ::Resolv::DNS::Message.decode(binary_dns_message).question.first == [
      ::Resolv::DNS::Name.create("#{hostname}."),
      ::Resolv::DNS::Resource::IN.const_get(record_type.upcase)
    ]
  end
end
