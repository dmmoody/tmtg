# frozen_string_literal: true

module Base
  module TokenHandler

    protected

    def bearer_token
      cached_token = redis.get(bearer_token_cache_key)
      access_data = parse_token(cached_token)
      access_data && access_data[:access_token] ? access_data[:access_token] : set_access_data
    end

    def parse_token(cached_token)
      JSON.parse(cached_token, symbolize_names: true) if cached_token
    end

    def set_access_data
      access_data = fetch_access_data.body
      expires_at = Time.parse(access_data[:expires_at])
      now = Time.current
      expires_in_seconds = expires_at - now

      set_token_in_cache(access_data, expires_in_seconds) if expires_in_seconds.positive?
      access_data[:access_token]
    end

    def set_token_in_cache(access_data, expires_in_seconds)
      redis.set(bearer_token_cache_key, access_data.to_json, ex: expires_in_seconds)
    end

    def bearer_token_cache_key
      "#{service}_bearer_token"
    end

    def headers
      super.merge('Authorization' => "Bearer #{bearer_token}")
    end

    private

    def redis = Base::RedisConnection.instance
  end
end