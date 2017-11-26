# frozen_string_literal: true

require 'arbitrager/exchange'

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
      pairings.add(*exchange.supported_pairings)
    end

    def find_opportunity
      pairings.each do |pairing|
        opportunities = exchanges
                        .select { |e| e.supported_pairings.include?(pairing) }
                        .map { |e| [e, e.fetch_price(pairing)] }
        pp opportunities
      end
    end
  end
end
