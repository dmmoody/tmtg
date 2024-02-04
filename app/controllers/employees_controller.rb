class EmployeesController < ApplicationController

  def index; end

  def list
    response = EmployeeService::ListEmployees.new.call
    @employees = response.body
    render layout: false
  end
end