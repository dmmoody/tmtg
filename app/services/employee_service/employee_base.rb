# frozen_string_literal: true

module EmployeeService
  class EmployeeBase
    include Base::Request
    include Base::ServiceConfig

    def initialize(opts: {}, config: external_service_config)
      @opts = opts
      @config = config
    end

    private

    def url = "#{base_url}#{request_path}"

    %i[request_method request_path request_body].each do |m|
      define_method(m) do
        raise NotImplementedError, "##{m} must be implemented in the including class"
      end
    end
  end
end