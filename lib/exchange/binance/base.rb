# frozen_string_literal: true

require 'concurrent'

require 'exchange/binance/client'

module Exchange
  module Binance
    class Base
      attr_reader :client

      def initialize(api_key, secret)
        @client = ::Exchange::Binance::Client.new(api_key, secret)
      end

      def setup; end

      def supported_pairs
        [
          Pair.new('KNC/BTC/USDT'), Pair.new('KNC/ETH/USDT'),
          Pair.new('OMG/ETH'),
          Pair.new('REQ/BTC/USDT'), Pair.new('REQ/ETH/USDT'),
          Pair.new('OMG/BTC/USDT'), Pair.new('OMG/ETH/USDT'),
          Pair.new('ZRX/BTC/USDT'), Pair.new('ZRX/ETH/USDT')
        ].freeze
      end

      def fetch_price(pair)
        raise ArgumentError unless supported_pairs.include?(pair)

        merge_price pair.sub_pairs do |pair|
          best_bidask(client.order_book(pair.to_s.delete('/')))
        end
      end

      private

      def best_bidask(book)
        [book['bids'][0][0].to_f, book['asks'][0][0].to_f]
      end

      def merge_price(pairs)
        pairs
          .map { |pair| Concurrent::Future.execute { yield pair } }
          .each { |symbol| symbol.wait_or_cancel(3) }
          .map(&:value)
          .reduce([1, 1]) do |state, bidask|
          [state[0] * bidask[0], state[1] * bidask[1]]
        end
      end
    end
  end
end
