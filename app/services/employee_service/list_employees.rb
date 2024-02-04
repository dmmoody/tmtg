# frozen_string_literal: true

module EmployeeService
  class ListEmployees < EmployeeBase
    include Base::TokenHandler
    include Base::ResponseCache

    private

    def request_method = :get

    def request_path = '/assignment/employee/list'

    def request_body = nil

    def on_complete_actions(response)
      if response.success?
        cache_response(response).tap do |cache_id|
          LoadEmployeesJob.perform_async(cache_id) if cache_id
        end
      end
    end

    def fetch_access_data
      EmployeeService::Preauthorization.new.call
    end
  end
end