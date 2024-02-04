# frozen_string_literal: true

module Base
  module ServiceConfig

    protected

    def external_service_config
      @external_service_config ||= fetch_external_service_config
    end

    def fetch_external_service_config
      Rails.application.config_for("services/#{service}")
    rescue RuntimeError => e
      Rails.logger.error "Configuration for #{service} not found: #{e.message}"
      {}
    end

    def service
      self.class.name.deconstantize.underscore
    end
  end
end