# frozen_string_literal: true

require 'bx_in_th_api'
require 'concurrent'

module Arbitrager
  module Exchange
    class BxInTh
      attr_reader :bx, :omg_thb, :eth_thb
      def initialize(api_key, secret)
        @bx = ::BxInThAPI.new(api_key, secret)
      end

      def setup
        pairings = bx.currency_pairings
        @omg_thb = pairings.find { |_, pair| match_pair(pair, 'THB', 'OMG') }[1]
        @eth_thb = pairings.find { |_, pair| match_pair(pair, 'THB', 'ETH') }[1]
      end

      def supported_pairings
        [Pairing.new('OMG/ETH')].freeze
      end

      def fetch_price(pairing)
        raise ArgumentError unless supported_pairings.include?(pairing)

        OmgEthThbPair.new(
          OrderBook.for(bx, omg_thb['pairing_id']),
          OrderBook.for(bx, eth_thb['pairing_id'])
        ).opportunity
      end

      private

      def match_pair(pair, pri, sec)
        pair['primary_currency'] == pri && pair['secondary_currency'] == sec
      end

      class OrderBook
        attr_reader :future
        def self.for(bx, pairing)
          new(Concurrent::Future.execute { bx.order_book(pairing) })
        end

        def initialize(future)
          @future = future
        end

        def best_bid
          return unless future.wait_or_cancel(3)
          future.value['bids'][0][0].to_f
        end

        def best_ask
          return unless future.wait_or_cancel(3)
          future.value['asks'][0][0].to_f
        end
      end

      class OmgEthThbPair
        attr_reader :omg_book, :eth_book
        def initialize(omg_book, eth_book)
          @omg_book = omg_book
          @eth_book = eth_book
        end

        def opportunity
          [
            omg_book.best_bid / eth_book.best_ask,
            omg_book.best_ask / eth_book.best_bid
          ]
        end
      end
    end
  end
end
