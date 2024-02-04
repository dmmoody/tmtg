# frozen_string_literal: true

require 'rails_helper'
require 'redis'

RSpec.describe Base::RedisConnection do
  describe '.instance' do
    it 'returns a Redis instance' do
      expect(described_class.instance).to be_an_instance_of(Redis)
    end

    it 'returns the same instance on subsequent calls' do
      instance1 = described_class.instance
      instance2 = described_class.instance
      expect(instance1.object_id).to eq(instance2.object_id)
    end

    it 'connects to the correct Redis URL' do
      expect(described_class.instance.connection[:id]).to eq('redis://localhost:6379/1')
    end
  end
end