# frozen_string_literal: true

require 'arbitrager'
require 'exchange'

module Bitbot
  class Base
    def initialize
      Arbitrager.new.tap do |a|
        [
          Exchange::Binance.new(ENV['BINANCE_API_KEY'], ENV['BINANCE_API_SECRET']),
          Exchange::BxInTh.new(ENV['BX_API_KEY'], ENV['BX_API_SECRET'])
        ].each(&a.method(:register_exchange))
      end
    end
  end
end
