require_relative '../../lib/api_caller'
require 'ostruct'

RSpec.describe ApiCaller do

  describe '.get' do

    it 'should perform a http get' do
      response = described_class.get('http://www.trovaprezzi.it/')

      expect(response).to include('Trovaprezzi')
    end

    it 'should perform a https get' do
      response = described_class.get('https://rubygems.org')

      expect(response).to include('RubyGems')
    end

    it 'should return nil when resource is not available' do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(Timeout::Error)

      response = described_class.get('https://www.trovaprezzi.it/')

      expect(response).to be_nil
    end

    it 'should return nil when page not found' do
      response = described_class.get('https://www.trovaprezzi.it/404')

      expect(response).to be_nil
    end

    it 'should call logger' do
      logger = double(error: 'print error')

      expect(logger).to receive(:error)
      response = described_class.get('http://vvv.trovaprezzi.it/', logger)

      expect(response).to be_nil
    end

  end

  describe '.post' do

    it 'should perform a json http post' do
      request = OpenStruct.new(body: nil)
      uri = URI('http://www.google.com/')
      expect(Net::HTTP::Post).to receive(:new).with(uri, {'Content-Type' => 'application/json'}).and_return(request)

      described_class.post('http://www.google.com/', '{"key": "value"}')

      expect(request.body).to eq('{"key": "value"}')
    end

  end

end