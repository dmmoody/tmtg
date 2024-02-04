# frozen_string_literal: true

module Base
  class ServiceConnection
    class << self
      def build(url:, headers: {})
        Faraday.new(url:, headers:) do |builder|
          builder.request :json
          builder.response :json, content_type: /\bjson$/, parser_options: { symbolize_names: true }
          builder.use Faraday::Response::RaiseError
          builder.options.timeout = 5
          builder.options.open_timeout = 2
          builder.adapter Faraday.default_adapter
        end
      end
    end
  end
end