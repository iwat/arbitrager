require 'arbitrager'

module Bitbot
  class Base
    def dispatch
      Arbitrager.new.tap do |a|
        a.register_exchange(Arbitrager::Exchange::Binance.new('', ''))
        a.register_exchange(Arbitrager::Exchange::BxInTh.new('', ''))
      end
    end
  end
end
