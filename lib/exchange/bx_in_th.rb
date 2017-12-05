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
      pair.sub_pairs.map do |sub_pair|
        OrderBook.for(self, sub_pair)
      end
    end

    class OrderBook
      attr_reader :bx, :future, :invert, :pair

      def self.for(bx, pair)
        new(bx, pair).tap(&:execute)
      end

      def initialize(bx, pair)
        @bx = bx
        @pair = pair
      end

      def execute
        native_pair['pairing_id'].tap do |native_id|
          if native_id.negative?
            @invert = true
            native_id *= -1
          end

          @future = Concurrent::Future.execute do
            bx.client.order_book(native_id)
          end
        end
      end

      def best_bidask
        if future.wait_or_cancel(3)
          [best_bid, best_ask]
        else
          [0, 0]
        end
      end

      private

      def best_bid
        invert_price(future.value['bids'][0][0].to_f, future.value['asks'][0][0].to_f)
      end

      def best_ask
        invert_price(future.value['asks'][0][0].to_f, future.value['bids'][0][0].to_f)
      end

      def invert_price(offer, counter)
        if invert
          1 / counter
        else
          offer
        end
      end

      def compare_with(native_pair, pri, sec)
        native_pair['primary_currency'] == pri &&
          native_pair['secondary_currency'] == sec
      end

      def invert_pair
        bx.native_pairs
          .select { |native_pair| compare_with(native_pair, pair.base, pair.quote) }
          .first
          .tap { |p| p['pairing_id'] *= -1 }
      end

      def native_pair
        bx.native_pairs
          .select { |native_pair| compare_with(native_pair, pair.quote, pair.base) }
          .first || invert_pair
      end
    end
  end
end
