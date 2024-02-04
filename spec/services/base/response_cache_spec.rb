# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Base::ResponseCache do
  let(:dummy_class) { Class.new { include Base::ResponseCache } }
  let(:instance) { dummy_class.new }
  let(:response) { instance_double("Response", url: 'http://example.com', body: { key: 'value' }) }
  let(:redis) { instance_double(Redis) }

  before do
    allow(Base::RedisConnection).to receive(:instance).and_return(redis)
    allow(redis).to receive(:get)
    allow(redis).to receive(:multi).and_yield
    allow(redis).to receive(:setnx).and_return(true)
    allow(redis).to receive(:set)
    allow(redis).to receive(:del)
  end

  describe '#cache_response' do
    it 'caches the response in Redis' do
      instance.send(:cache_response, response)
      expect(redis).to have_received(:setnx)
      expect(redis).to have_received(:set)
    end
  end
end