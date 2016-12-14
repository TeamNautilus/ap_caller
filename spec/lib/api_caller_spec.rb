require_relative '../../lib/api_caller'
require 'ostruct'

RSpec.describe ApiCaller do

  describe '.get' do

    it 'should perform a http get' do
      response = described_class.get(uri_string: 'http://www.trovaprezzi.it/')

      expect(response).to include('Trovaprezzi')
    end

    it 'should perform a https get' do
      response = described_class.get(uri_string: 'https://rubygems.org')

      expect(response).to include('RubyGems')
    end

    it 'should return nil when resource is not available' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(Timeout::Error)

      response = described_class.get(uri_string: 'https://www.trovaprezzi.it/')

      expect(response).to be_nil
    end

    it 'should return nil when page not found' do
      response = described_class.get(uri_string: 'https://www.trovaprezzi.it/404')

      expect(response).to be_nil
    end

    it 'should call logger' do
      logger = double(error: 'print error')

      expect(logger).to receive(:error)
      response = described_class.get(uri_string: 'http://vvv.trovaprezzi.it/', logger: logger)

      expect(response).to be_nil
    end

  end

  describe '.post' do

    context 'params in body' do
      it 'should perform a json http post' do
        request = OpenStruct.new(body: nil)
        uri = URI('http://www.google.com/')
        expect(Net::HTTP::Post).to receive(:new).with(uri, {'Content-Type' => 'application/json'}).and_return(request)

        described_class.post(uri_string: 'http://www.google.com/', params: '{"key": "value"}', content_type: {'Content-Type' => 'application/json'})

        expect(request.body).to eq('{"key": "value"}')
      end
    end

    context 'params in url' do
      it 'should perform a standard http post' do
        request = double
        uri = URI('http://www.google.com/')
        expect(Net::HTTP::Post).to receive(:new).with(uri).and_return(request)

        expect_any_instance_of(Net::HTTP).to receive(:request).with(request, 'key=value&key2=2')
        described_class.post(uri_string: 'http://www.google.com/', params: {key: 'value', key2: 2})
      end
    end
  end

  describe '.delete' do

    it 'should perform delete' do
      uri = URI('http://www.google.com/drop_db/users')
      expect(Net::HTTP::Delete).to receive(:new).with(uri)

      described_class.delete(uri_string: uri)
    end

  end

end
