# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoreEmployeeRecordJob, type: :worker do
  let(:record_key) { 'employee_record_123' }
  let(:employee_data) do
    {
      id: '1c8f83b5-ae88-45ec-a10a-e5ff6b8c1d63',
      date_of_birth: '1997-07-26',
      email: 'chara@effertz.net',
      first_name: 'Blanca',
      last_name: 'Kunde',
      address: '830 Schmidt Wall, Port Elliott, PA 94677-2473',
      country: 'Georgia',
      bio: [
        'Id quo qui. Accusamus et at. Est incidunt necessitatibus.',
        'Voluptatum incidunt nihil. Sit dignissimos magnam. Harum magni nihil.',
        'Nihil omnis temporibus. Similique qui dolorum. Placeat voluptatibus enim.'
      ],
      rating: 0.87
    }.to_json
  end

  before do
    allow(Base::RedisConnection.instance).to receive(:getdel).with(record_key).and_return(employee_data)
  end

  it 'creates or updates an employee record with the data from Redis' do
    expect { described_class.new.perform(record_key) }.to change(Employee, :count).by(1)
    employee = Employee.find_by(employee_id: '1c8f83b5-ae88-45ec-a10a-e5ff6b8c1d63')

    expect(employee).to have_attributes(
      first_name: 'Blanca',
      last_name: 'Kunde',
      email: 'chara@effertz.net',
      date_of_birth: Date.parse('1997-07-26'),
      address: '830 Schmidt Wall, Port Elliott, PA 94677-2473',
      country: 'Georgia',
      bio: [
        'Id quo qui. Accusamus et at. Est incidunt necessitatibus.',
        'Voluptatum incidunt nihil. Sit dignissimos magnam. Harum magni nihil.',
        'Nihil omnis temporibus. Similique qui dolorum. Placeat voluptatibus enim.'
      ],
      rating: 0.87
    )
  end
end