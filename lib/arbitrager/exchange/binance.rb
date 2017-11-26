# frozen_string_literal: true

require 'concurrent'
require 'exchange/binance'

module Arbitrager
  module Exchange
    class Binance
      attr_reader :exchange, :omg_thb, :eth_thb

      def initialize(api_key, secret)
        @exchange = ::Exchange::Binance.new(api_key, secret)
      end

      def setup; end

      def supported_pairings
        ['OMG/ETH'].freeze
      end

      def opportunity(pairing)
        raise ArgumentError unless supported_pairings.include?(pairing)

        book = exchange.order_book
        [book['bids'][0][0].to_f, book['asks'][0][0].to_f]
      end
    end
  end
end
