require "builder"
require "experian/version"
require "experian/constants"
require "experian/error"
require "experian/client"
require "experian/request"
require "experian/response"
require "experian/connect_check"
require 'experian/credit_profile'

module Experian
  include Experian::Constants

  class << self

    attr_accessor :eai, :preamble, :op_initials, :subcode, :user, :password, :vendor_number
    attr_accessor :test_mode, :proxy_url, :use_proxy_url

    def configure
      yield self
    end

    def test_mode?
      !!test_mode
    end

    def default_ecals_uri
      uri = URI(Experian::LOOKUP_SERVLET_URL)
      uri.query = URI.encode_www_form(
        'lookupServiceName' => Experian::LOOKUP_SERVICE_NAME,
        'lookupServiceVersion' => Experian::LOOKUP_SERVICE_VERSION,
        'serviceName' => service_name,
        'serviceVersion' => Experian::SERVICE_VERSION,
        'responseType' => 'text/plain'
      )
      uri
    end

    def net_connect_uri(options = {})
      ecals_uri = options.fetch(:ecals_uri, nil)
      if ecals_lookup_required?
        if ecals_uri.present?
          perform_ecals_lookup(ecals_uri)
        else
          perform_ecals_lookup
        end
      end

      user = options.fetch(:user, nil)
      password = options.fetch(:password, nil)

      # setup basic authentication
      @net_connect_uri.user = user
      @net_connect_uri.password = password

      @net_connect_uri
    end

    def perform_ecals_lookup(ecals_uri = nil)
      if ecals_uri.blank?
        ecals_uri = default_ecals_uri
      end
      curl = ::Experian::Client.start_curl(ecals_uri.to_s)
      curl.http_get
      body = curl.body_str.strip
      @net_connect_uri = URI.parse(body)
      p "ECALS URL: #{@net_connect_uri}"
      assert_experian_domain
      @ecals_last_update = Time.now
    rescue ::Curl::Easy::Error => e
      raise Experian::ClientError, "Could not connect to Experian: #{e.message}"
    end

    def ecals_lookup_required?
      @net_connect_uri.nil? || @ecals_last_update.nil? || Time.now - @ecals_last_update > Experian::ECALS_TIMEOUT
    end

    def assert_experian_domain
      unless @net_connect_uri.host.end_with?('.experian.com')
        @net_connect_uri = nil
        raise Experian::ClientError, "Could not authenticate connection to Experian, unexpected host name."
      end
    end

    def service_name
      test_mode? ? Experian::SERVICE_NAME_TEST : Experian::SERVICE_NAME
    end

  end
end
