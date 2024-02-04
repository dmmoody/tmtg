# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Base::ServiceConnection do
  describe '.build' do
    let(:url) { 'http://example.com/' }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:connection) { described_class.build(url: url, headers: headers) }

    describe 'builds a Faraday connection with the given parameters' do
      it 'returns a Faraday::Connection' do
        expect(connection).to be_a(Faraday::Connection)
      end

      it 'sets the correct url' do
        expect(connection.url_prefix.to_s).to eq(url)
      end

      it 'includes the correct headers' do
        expect(connection.headers).to include(headers)
      end
    end

    describe 'sets the correct timeout settings' do
      it 'sets the open/read timeout' do
        expect(connection.options.timeout).to eq(5)
      end

      it 'sets the connection open timeout' do
        expect(connection.options.open_timeout).to eq(2)
      end
    end
  end
end