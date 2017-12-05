# frozen_string_literal: true

require 'arbitrager'

module Bitbot
  class Base
    def dispatch
      Arbitrager.new.tap do |a|
        a.register_exchange(Exchange::Binance.new('', ''))
        a.register_exchange(Exchange::BxInTh.new('', ''))
      end
    end
  end
end
