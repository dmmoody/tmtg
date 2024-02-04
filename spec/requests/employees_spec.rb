# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  describe 'GET #index' do
    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #list' do
    let(:service_response) { double(body: 'response_body') }

    before do
      allow(EmployeeService::ListEmployees).to receive(:new).and_return(service_response)
      allow(service_response).to receive(:call).and_return(service_response)
    end

    it 'calls the EmployeeService::ListEmployees service' do
      expect(EmployeeService::ListEmployees).to receive(:new).and_return(service_response)
      expect(service_response).to receive(:call).and_return(service_response)
      get :list
    end

    it 'assigns @employees' do
      get :list
      expect(assigns(:employees)).to eq 'response_body'
    end

    it 'renders the list view without a layout' do
      get :list
      expect(response).to render_template :list
      expect(response).to render_template(layout: false)
    end
  end
end