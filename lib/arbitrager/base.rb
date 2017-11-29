# frozen_string_literal: true

module Arbitrager
  class Base
    attr_reader :exchanges, :pairs

    def initialize
      @exchanges = Set.new
      @pairs = Set.new
    end

    def register_exchange(exchange)
      exchange.setup

      exchanges << exchange
      exchange.supported_pairs.each do |pair|
        pairs.add(pair)
      end
    end

    def find_opportunity
      pairs
        .select { |pair| pair.symbols.size == 2 }
        .each do |pair|
          fetch_prices(pair).tap do |exchange_price|
            lowest_bid = exchange_price.min_by { |_, bidask| bidask[0] }
            highest_ask = exchange_price.max_by { |_, bidask| bidask[1] }
            if lowest_bid[0] != highest_ask[0]
              puts "OPPORTUNITY #{lowest_bid[0]} #{lowest_bid[1][0]} -> #{highest_ask[0]} #{highest_ask[1][1]} #{highest_ask[1][1] * 100 / lowest_bid[1][0]}"
            end
          end
        end
    end

    private

    def fetch_prices(pair)
      exchanges
        .select { |e| e.supported_pairs.include?(pair) }
        .map { |e| [e, e.fetch_price(pair)] }
    end
  end
end
