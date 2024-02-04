# frozen_string_literal: true

module EmployeeService
  class Preauthorization < EmployeeBase
    private

    def request_method = :post

    def request_path = '/assignment/token'

    def request_body = body_options.to_json

    def body_options
      {
        grant_type: @opts[:grant_type] || @config[:grant_type],
        client_id: @opts[:client_id] || @config[:client_id],
        client_secret: @opts[:client_secret] || @config[:client_secret],
        username: @opts[:username] || @config[:username],
        password: @opts[:password] || @config[:password],
      }
    end
  end
end