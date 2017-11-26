# frozen_string_literal: true

require 'exchange/binance/options'
require 'exchange/binance/private'
require 'exchange/binance/public'
require 'exchange/binance/base'

module Exchange
  module Binance
    def self.new(api_key, secret)
      Base.new(api_key, secret)
    end
  end
end
