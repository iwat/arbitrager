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
        %w[
          OMG/ETH
          OMG/BTC/USDT OMG/ETH/USDT
          REQ/BTC/USDT REQ/ETH/USDT
          ZRX/BTC/USDT ZRX/ETH/USDT
        ].freeze
      end

      def fetch_price(pairing)
        raise ArgumentError unless supported_pairings.include?(pairing)

        merge_price build_pairs(pairing.split('/')) do |pair|
          book = exchange.order_book(pair)
          [book['bids'][0][0].to_f, book['asks'][0][0].to_f]
        end
      end

      private

      def build_pairs(symbols)
        symbols
          .zip(symbols[1..-1])
          .reject { |s| s[1].nil? }
          .map(&:join)
      end

      def merge_price(pairs)
        pairs
          .map { |pair| Concurrent::Future.execute { yield pair } }
          .each { |symbol| symbol.wait_or_cancel(3) }
          .map(&:value)
          .reduce([1, 1]) { |state, bidask| [state[0] * bidask[0], state[1] * bidask[1]] }
      end
    end
  end
end
