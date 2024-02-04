# frozen_string_literal: true

module Base
  class RedisConnection
    class << self
      def instance
        @instance ||= Redis.new(url: 'redis://localhost:6379/1')
      end
    end
  end
end