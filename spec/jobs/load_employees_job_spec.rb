# # frozen_string_literal: true
#
# require 'rails_helper'
#
# RSpec.describe LoadEmployeesJob, type: :job do
#   let(:records_key) { 'employees:records' }
#   let(:employee_records) do
#     [
#       {
#         'id' => '1c8f83b5-ae88-45ec-a10a-e5ff6b8c1d63',
#         'date_of_birth' => '1997-07-26',
#         'email' => 'chara@effertz.net',
#         'first_name' => 'Blanca',
#         'last_name' => 'Kunde',
#         'address' => '830 Schmidt Wall, Port Elliott, PA 94677-2473',
#         'country' => 'Georgia',
#         'bio' => [
#           'Id quo qui. Accusamus et at. Est incidunt necessitatibus.',
#           'Voluptatum incidunt nihil. Sit dignissimos magnam. Harum magni nihil.',
#           'Nihil omnis temporibus. Similique qui dolorum. Placeat voluptatibus enim.'
#         ],
#         'rating' => 0.87
#       }
#     ].to_json
#   end
#
#   before do
#     allow(Base::RedisConnection.instance).to receive(:get).with(records_key).and_return(employee_records)
#     allow(Base::RedisConnection.instance).to receive(:setnx).and_return(true)
#     Sidekiq::Testing.fake!
#   end
#
#   it 'enqueues a StoreEmployeeRecordJob for each record' do
#     expect {
#       LoadEmployeesJob.perform_async(records_key)
#     }.to change(StoreEmployeeRecordJob.jobs, :size).by(1)
#
#     job_args = StoreEmployeeRecordJob.jobs.last['args']
#     expect(job_args).to include('employee:1c8f83b5-ae88-45ec-a10a-e5ff6b8c1d63')
#   end
# end