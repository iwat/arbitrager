# frozen_string_literal: true

require 'bx_in_th_api'
require 'concurrent'

module Exchange
  class BxInTh
    attr_reader :client, :native_pairs
    def initialize(api_key, secret)
      @client = ::BxInThAPI.new(api_key, secret)
    end

    def setup
      @native_pairs = client.currency_pairings.values
    end

    def supported_pairs
      [
        Pair.new('ETH/THB'),
        Pair.new('OMG/THB'),
        Pair.new('OMG/THB/ETH')
      ].freeze
    end

    def fetch_price(pair)
      raise ArgumentError unless supported_pairs.include?(pair)

      merge_price(order_books(pair).map(&:best_bidask))
    end

    private

    def merge_price(prices)
      prices.reduce([1, 1]) do |state, bidask|
        [state[0] * bidask[0], state[1] * bidask[1]]
      end
    end

    def order_books(pair)
      pair.sub_pairs.map do |pair|
        OrderBook.for(client, resolve_native_pair(pair)['pairing_id'])
      end
    end

    def resolve_invert_pair(pair)
      native_pairs.select do |native_pair|
        native_pair['primary_currency'] == pair.base &&
          native_pair['secondary_currency'] == pair.quote
      end.first.tap { |p| p['pairing_id'] *= -1 }
    end

    def resolve_native_pair(pair)
      native_pairs.select do |native_pair|
        native_pair['primary_currency'] == pair.quote &&
          native_pair['secondary_currency'] == pair.base
      end.first || resolve_invert_pair(pair)
    end

    class OrderBook
      attr_reader :future, :invert

      def self.for(client, pair)
        if pair < 0
          invert = true
          pair *= -1
        end

        client.order_book(pair)
        new(Concurrent::Future.execute { client.order_book(pair) }, invert)
      end

      def initialize(future, invert)
        @future = future
        @invert = invert
      end

      def best_bid
        return unless future.wait_or_cancel(3)
        invert ? 1 / future.value['asks'][0][0].to_f : future.value['bids'][0][0].to_f
      end

      def best_ask
        return unless future.wait_or_cancel(3)
        invert ? 1 / future.value['bids'][0][0].to_f : future.value['asks'][0][0].to_f
      end

      def best_bidask
        [best_bid, best_ask]
      end
    end
  end
end
