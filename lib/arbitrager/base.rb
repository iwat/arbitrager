# frozen_string_literal: true

module Arbitrager
  class Base
    attr_reader :exchanges, :pairings

    def initialize
      @exchanges = Set.new
      @pairings = Set.new
    end

    def register_exchange(exchange)
      exchange.setup

      exchanges << exchange
      exchange.supported_pairings.each do |pairing|
        pairings.add(pairing)
      end
    end

    def find_opportunity
      pairings
        .select { |pairing| pairing.symbols.size == 2 }
        .each do |pairing|
          fetch_prices(pairing).tap do |exchange_price|
            lowest_bid = exchange_price.min_by { |_, bidask| bidask[0] }
            highest_ask = exchange_price.max_by { |_, bidask| bidask[1] }
            if lowest_bid[0] != highest_ask[0]
              puts "OPPORTUNITY #{lowest_bid[1][0]} -> #{highest_ask[1][1]}"
            end
          end
        end
    end

    private

    def fetch_prices(pairing)
      exchanges
        .select { |e| e.supported_pairings.include?(pairing) }
        .map { |e| [e, e.fetch_price(pairing)] }
    end
  end
end
