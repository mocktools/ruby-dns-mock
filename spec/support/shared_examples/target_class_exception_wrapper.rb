# frozen_string_literal: true

module DnsMock
  RSpec.shared_examples 'target class exception wrapper' do
    it 'wraps target class exception and raises as customized error' do
      expect { create_factory }.to raise_error(DnsMock::RecordContextError, error_context)
    end
  end
end
