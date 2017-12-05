# frozen_string_literal: true

require 'exchange/binance/base'

module Exchange
  module Binance
    def self.new(api_key, secret)
      Base.new(api_key, secret)
    end
  end
end
