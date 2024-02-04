# frozen_string_literal: true

module Base
  module Request

    def call
      execute_request
    end

    protected

    def connection
      Base::ServiceConnection.build(url:, headers:)
    end

    def execute_request(retry_attempted: false)
      response = connection.send(request_method) do |req|
        req.url(url)
        req.body = request_body if request_body
      end

      response.on_complete do |env|
        on_complete_actions(env)
      end

      response
    rescue Faraday::ForbiddenError, Faraday::UnauthorizedError
      unless retry_attempted
        expire_token
        retry_attempted = true
        retry
      end
    end

    def headers = { 'Content-Type' => 'application/json' }

    def url = "#{base_url}#{request_path}"

    def base_url = @opts[:base_url] || @config[:base_url]

    def request_body = nil

    def on_complete_actions(_response); end

    %i[
      request_method
      url
      fetch_access_data
    ].each do |m|
      define_method(m) do
        raise NotImplementedError, "##{m} must be implemented in the including class"
      end
    end

    private

    def expire_token
      redis.del(bearer_token_cache_key)
    end

    def redis = Base::RedisConnection.instance
  end
end