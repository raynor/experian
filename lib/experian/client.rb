require 'curb'

module Experian
  class Client

    cattr_accessor :verbose
    attr_reader :request, :response

    def self.start_curl(url)
      Curl::Easy.new(url).tap do |c|
        c.proxy_url = Experian.proxy_url.presence if Experian.use_proxy_url
        c.verbose = verbose
      end
    end

    def submit_request(options = {})
      if options.fetch(:log_request_xml, false)
        p request.xml
      end

      url = Experian.net_connect_uri(options).to_s

      curl = self.class.start_curl(url)
      curl.headers.merge! request_headers
      curl.http_post(request_body)

      raise Experian::Forbidden, 'Invalid Experian login credentials' if invalid_login?(curl)
      curl.body_str

    rescue ::Curl::Easy::Error => e
      raise Experian::ClientError, "Could not connect to Experian: #{e.message}"
    end

    def request_body
      URI.encode_www_form('NETCONNECT_TRANSACTION' => request.xml)
    end

    def request_headers
      { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def invalid_login?
      !!(@raw_response.headers["Location"] =~ /sso_logon/)
    end

  end
end
