# frozen_string_literal: true

require 'bx_in_th_api'
require 'concurrent'

module Exchange
  class BxInTh
    attr_reader :client, :native_pairings
    def initialize(api_key, secret)
      @client = ::BxInThAPI.new(api_key, secret)
    end

    def setup
      @native_pairings = client.currency_pairings.values
    end

    def supported_pairings
      [
        Pairing.new('ETH/THB'),
        Pairing.new('OMG/THB'),
        Pairing.new('OMG/THB/ETH')
      ].freeze
    end

    def fetch_price(pairing)
      raise ArgumentError unless supported_pairings.include?(pairing)

      merge_price(order_books(pairing).map(&:best_bidask))
    end

    private

    def merge_price(prices)
      prices.reduce([1, 1]) do |state, bidask|
        [state[0] * bidask[0], state[1] * bidask[1]]
      end
    end

    def order_books(pairing)
      pairing.sub_pairs.map do |pairing|
        OrderBook.for(client, resolve_native_pairing(pairing)['pairing_id'])
      end
    end

    def resolve_invert_pairing(pairing)
      native_pairings.select do |native_pairing|
        native_pairing['primary_currency'] == pairing.base &&
          native_pairing['secondary_currency'] == pairing.quote
      end.first.tap { |p| p['pairing_id'] *= -1 }
    end

    def resolve_native_pairing(pairing)
      native_pairings.select do |native_pairing|
        native_pairing['primary_currency'] == pairing.quote &&
          native_pairing['secondary_currency'] == pairing.base
      end.first || resolve_invert_pairing(pairing)
    end

    class OrderBook
      attr_reader :future, :invert

      def self.for(client, pairing)
        if pairing < 0
          invert = true
          pairing *= -1
        end

        client.order_book(pairing)
        new(Concurrent::Future.execute { client.order_book(pairing) }, invert)
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
