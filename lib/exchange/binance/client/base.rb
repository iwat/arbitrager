# frozen_string_literal: true

require 'openssl'

require 'exchange/binance/client/options'
require 'exchange/binance/client/private'
require 'exchange/binance/client/public'
require 'exchange/binance/client/simple_encoder'

module Exchange
  module Binance
    module Client
      class Base
        include Public
        include Private
        include Options

        attr_reader :api_key, :api_secret

        BASE_URL = 'https://api.binance.com/api'

        def initialize(api_key, api_secret)
          @api_key = api_key
          @api_secret = api_secret
        end

        protected

        def __private(url, method = :post, params = {}, headers = {})
          auth = api_auth_fields(params)
          headers = headers.merge(auth[:headers])
          params = params.merge(auth[:params])
          __request(url, method: method, params: params, headers: headers)
        end

        def __public(url, params = {}, headers = {})
          __request(url, method: :get, params: params, headers: headers)
        end

        def __request(url, method: :get, params: {}, headers: {})
          response = agent.send(method) do |req|
            req.url(url.to_s)
            req.headers = headers
            req.options.timeout = 5
            req.options.open_timeout = 5
            req.send(method == :get ? 'params=' : 'body=', params)
          end
          JSON.parse(response.body) if response.success?
        end

        def agent
          @agent ||= Faraday.new(url: BASE_URL, request: { params_encoder: SimpleEncoder.new }) do |faraday|
            faraday.request(:url_encoded)
            faraday.response(:logger, Faraday::Response::Logger.new(STDOUT), bodies: true)
            faraday.adapter(Faraday.default_adapter)
          end
        end

        def api_auth_fields(params)
          more_params = { timestamp: (Time.now.to_f * 1000).to_i }
          data = URI.encode_www_form(params.merge(more_params))
          more_params[:signature] = OpenSSL::HMAC.hexdigest('SHA256', api_secret, data)

          {
            headers: { 'X-MBX-APIKEY' => api_key },
            params: more_params
          }
        end
      end
    end
  end
end
