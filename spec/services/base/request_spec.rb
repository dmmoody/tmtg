# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Base::Request do
  let(:dummy_class) { Class.new { include Base::Request } }
  let(:instance) { dummy_class.new }

  describe '#call' do
    it 'calls execute_request' do
      expect(instance).to receive(:execute_request)
      instance.call
    end
  end
end