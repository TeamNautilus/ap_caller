require 'net/http'

class ApiCaller

  def self.get(uri_string:, logger: nil)
    response = nil

    uri = escaped_uri(uri_string)

    begin
      Net::HTTP.start(uri.host, uri.port, {use_ssl: uri.scheme == 'https', open_timeout: 1}) do |http|
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
      end
    rescue Exception => e
      logger.error("[API FAIL] - URI: [#{uri_string}] - Message: #{e.message}\n #{e.backtrace.join("\n ")}") if logger
    end

    response.is_a?(Net::HTTPSuccess) ? response.body&.force_encoding(Encoding::UTF_8) : nil
  end

  def self.post(uri_string:, params:, content_type: nil, logger: nil)
    if content_type
      body_params_post(uri_string: uri_string, params: params, content_type: content_type, logger: logger)
    else
      url_params_post(uri_string: uri_string, params: params, logger: logger)
    end
  end

  def self.delete(uri_string:, logger: nil)
    response = nil

    uri = escaped_uri(uri_string)
    begin
      Net::HTTP.start(uri.host, uri.port, {use_ssl: uri.scheme == 'https', open_timeout: 1}) do |http|
        request = Net::HTTP::Delete.new(uri)
        response = http.request(request)
      end
    rescue Exception => e
      logger.error("[API FAIL] - URI: [#{uri_string}] - Message: #{e.message}\n #{e.backtrace.join("\n ")}") if logger
    end

    response.is_a?(Net::HTTPSuccess) ? response.body&.force_encoding(Encoding::UTF_8) : nil
  end

  private

  def self.escaped_uri(uri)
    URI(URI.escape(uri))
  end

  def self.url_params_post(uri_string:, params:, logger: nil)
    response = nil

    uri = escaped_uri(uri_string)
    begin
      Net::HTTP.start(uri.host, uri.port, {use_ssl: uri.scheme == 'https', open_timeout: 1, read_timeout: 1}) do |http|
        request = Net::HTTP::Post.new(uri)
        post_data = URI.encode_www_form(params)
        response = http.request(request, post_data)
        response.body
      end
    rescue Exception => e
      logger.error("[API FAIL] - URI: [#{uri_string}] - Message: #{e.message}\n #{e.backtrace.join("\n ")}") if logger
    end
  end

  def self.body_params_post(uri_string:, params:, content_type: nil, logger: nil)
    response = nil

    uri = escaped_uri(uri_string)
    begin
      Net::HTTP.start(uri.host, uri.port, {use_ssl: uri.scheme == 'https', open_timeout: 1, read_timeout: 1}) do |http|
        request = Net::HTTP::Post.new(uri, content_type)
        request.body = params
        response = http.request(request)
        response.body
      end
    rescue Exception => e
      logger.error("[API FAIL] - URI: [#{uri_string}] - Message: #{e.message}\n #{e.backtrace.join("\n ")}") if logger
    end
  end

end
