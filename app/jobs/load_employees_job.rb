# frozen_string_literal: true

class LoadEmployeesJob
  include Sidekiq::Job

  def perform(records)
    deserialized = JSON.parse(redis.get(records))
    deserialized.each do |record|
      employee_key = "employee:#{record['id']}"
      redis.setnx(employee_key, record.to_json).tap do |set|
        StoreEmployeeRecordJob.perform_async(employee_key) if set
      end
    end
  end

  private

  def redis
    Base::RedisConnection.instance
  end
end