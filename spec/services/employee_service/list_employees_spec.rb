# f

require 'rails_helper'

RSpec.describe EmployeeService::ListEmployees, type: :service do
  subject(:service) { described_class.new }

  let(:fake_response) { instance_double(Faraday::Response, success?: true) }
  let(:cache_id) { 'some_cache_id' }

  before do
    allow_any_instance_of(EmployeeService::Preauthorization).to receive(:call).and_return(true)
    allow_any_instance_of(described_class).to receive(:fetch_access_data).and_return(true)
    allow_any_instance_of(described_class).to receive(:execute_request).and_return(fake_response)
    allow_any_instance_of(described_class).to receive(:cache_response).with(fake_response).and_return(cache_id)
    Sidekiq::Testing.fake!
  end

  describe '#on_complete_actions' do
    it 'enqueues LoadEmployeesJob when response is successful' do
      expect {
        service.send(:on_complete_actions, fake_response)
      }.to change(LoadEmployeesJob.jobs, :size).by(1)

      expect(LoadEmployeesJob.jobs.last['args']).to include(cache_id)
    end

    it 'does not enqueue LoadEmployeesJob when cache_id is nil' do
      allow_any_instance_of(described_class).to receive(:cache_response).with(fake_response).and_return(nil)

      expect {
        service.send(:on_complete_actions, fake_response)
      }.not_to change(LoadEmployeesJob.jobs, :size)
    end
  end
end