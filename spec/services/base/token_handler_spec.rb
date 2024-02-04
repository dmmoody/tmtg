# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Base::TokenHandler do
  let(:dummy_class) do
    Class.new do
      include Base::TokenHandler
      def service
        "dummy_service"
      end
    end
  end
  let(:instance) { dummy_class.new }
  let(:redis) { instance_double(Redis) }

  before do
    allow(Base::RedisConnection).to receive(:instance).and_return(redis)
  end

  describe '#parse_token' do
    it 'parses the token' do
      expect(instance.send(:parse_token, { access_token: 'token' }.to_json)).to eq({ access_token: 'token' })
    end
  end

  describe '#set_token_in_cache' do
    it 'sets the token in cache' do
      allow(redis).to receive(:set)
      instance.send(:set_token_in_cache, { access_token: 'new_token' }, 3600)
      expect(redis).to have_received(:set)
    end
  end

  describe '#bearer_token_cache_key' do
    it 'returns the correct cache key' do
      expect(instance.send(:bearer_token_cache_key)).to eq('dummy_service_bearer_token')
    end
  end
end