# frozen_string_literal: true

module Base
  module ResponseCache

    protected

    attr_reader :response, :old_response_digest

    def cache_response(response)
      @response = response
      @old_response_digest = redis.get(url_digest)
      if cache_in_redis
        delete_old_response
        composite_key
      end
    end

    private

    def url_digest = Digest::SHA256.hexdigest(response.url)

    def response_digest = Digest::SHA256.hexdigest(serialized_response_body)

    def composite_key = "#{url_digest}:#{response_digest}"

    def serialized_response_body = response.body.to_json

    def cache_in_redis
      success = false
      redis.multi do
        success = redis.setnx(composite_key, serialized_response_body)
        redis.set(url_digest, response_digest) if success
      end
      success
    end

    def delete_old_response
      redis.del("#{url_digest}:#{old_response_digest}") if old_response_digest
    end

    def redis = Base::RedisConnection.instance
  end
end