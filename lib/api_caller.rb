require 'net/http'

class ApiCaller

  def self.get(uri_string:, logger: nil)
    response = nil

    uri = URI(uri_string)
    begin
      Net::HTTP.start(uri.host, uri.port, {use_ssl: uri.scheme == 'https', open_timeout: 1}) do |http|
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
      end
    rescue Exception => e
      logger.error("[API FAIL] - URI: [#{uri_string}] - Message: #{e.message}\n #{e.backtrace.join("\n ")}") if logger
    end

    response.is_a?(Net::HTTPSuccess) ? response.body.force_encoding(Encoding::UTF_8) : nil
  end

  def self.post(uri_string:, params:, content_type: nil, logger: nil)
    response = nil

    uri = URI(uri_string)
    begin
      Net::HTTP.start(uri.host, uri.port, {use_ssl: uri.scheme == 'https', open_timeout: 1}) do |http|
        request = content_type ? Net::HTTP::Post.new(uri, content_type) : Net::HTTP::Post.new(uri)
        request.body = params
        response = http.request(request)
      end
    rescue Exception => e
      logger.error("[API FAIL] - URI: [#{uri_string}] - Message: #{e.message}\n #{e.backtrace.join("\n ")}") if logger
    end

    response
  end


end
