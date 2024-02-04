# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeeService::Preauthorization, type: :service do
  let(:service) { described_class.new(opts: opts) }
  let(:opts) { {} }

  describe '#initialize' do
    it 'initializes with default options' do
      expect(service.instance_variable_get(:@opts)).to eq(opts)
    end
  end

  describe '#request_body' do
    it 'returns the correct request body' do
      expected_body = {
        grant_type: opts[:grant_type] || service.instance_variable_get(:@config)[:grant_type],
        client_id: opts[:client_id] || service.instance_variable_get(:@config)[:client_id],
        client_secret: opts[:client_secret] || service.instance_variable_get(:@config)[:client_secret],
        username: opts[:username] || service.instance_variable_get(:@config)[:username],
        password: opts[:password] || service.instance_variable_get(:@config)[:password],
      }.to_json

      expect(service.send(:request_body)).to eq(expected_body)
    end
  end
end