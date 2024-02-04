# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Base::ServiceConfig do
  let(:dummy_class) do
    Class.new do
      include Base::ServiceConfig
      def self.name
        "DummyClass"
      end
    end
  end
  let(:instance) { dummy_class.new }

  describe '#external_service_config' do
    it 'fetches the external service config' do
      allow(Rails).to receive_message_chain(:application, :config_for).and_return({ 'key' => 'value' })
      expect(instance.send(:external_service_config)).to eq({ 'key' => 'value' })
    end
  end

  describe '#fetch_external_service_config' do
    context 'when the config is found' do
      it 'returns the config' do
        allow(Rails).to receive_message_chain(:application, :config_for).and_return({ 'key' => 'value' })
        expect(instance.send(:fetch_external_service_config)).to eq({ 'key' => 'value' })
      end
    end

    context 'when the config is not found' do
      it 'logs an error and returns an empty hash' do
        allow(Rails).to receive_message_chain(:application, :config_for).and_raise(RuntimeError)
        expect(Rails.logger).to receive(:error)
        expect(instance.send(:fetch_external_service_config)).to eq({})
      end
    end
  end
end