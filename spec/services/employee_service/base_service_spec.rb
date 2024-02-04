# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeeService::EmployeeBase, type: :service do
  let(:service) { described_class.new(opts: opts, config: config) }
  let(:opts) { {} }
  let(:config) { {} }

  describe '#initialize' do
    it 'initializes with default options and config' do
      expect(service.instance_variable_get(:@opts)).to eq(opts)
      expect(service.instance_variable_get(:@config)).to eq(config)
    end
  end
end