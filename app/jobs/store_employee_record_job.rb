# frozen_string_literal: true

class StoreEmployeeRecordJob
  include Sidekiq::Worker

  def perform(record)
    employee_record = JSON.parse(redis.getdel(record), symbolize_names: true)

    Employee.find_or_create_by(employee_id: employee_record[:id]) do |employee|
      employee.employee_id = employee_record[:id]
      employee.first_name = employee_record[:first_name]
      employee.last_name = employee_record[:last_name]
      employee.email = employee_record[:email]
      employee.phone = employee_record[:phone]
      employee.date_of_birth = employee_record[:date_of_birth]
      employee.address = employee_record[:address]
      employee.country = employee_record[:country]
      employee.bio = employee_record[:bio]
      employee.rating = employee_record[:rating]
    end
  end

  private

  def redis
    Base::RedisConnection.instance
  end
end