# frozen_string_literal: true

module Exchange
  module Binance
    class Base
      include Binance::Public
      include Binance::Private
      include Binance::Options

      attr_reader :api_key, :api_secret

      BASE_URL = 'https://api.binance.com/api'

      def initialize(api_key, api_secret)
        @api_key = api_key
        @api_secret = api_secret
      end

      protected

      def __private(url, params = {}, headers = {})
        params = params.merge(api_auth_fields)
        __request(url, method: :post, params: params, headers: headers)
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
        @agent ||= Faraday.new(url: BASE_URL)
      end

      def default_headers
        { 'Content-Type' => 'application/json' }
      end

      def api_auth_fields
        nonce = format('%18d', (Time.now.to_f * 10**9))
        signature = Digest::SHA2.hexdigest("#{api_key}#{nonce}#{api_secret}")
        { key: api_key, nonce: nonce, signature: signature }
      end
    end
  end
end
