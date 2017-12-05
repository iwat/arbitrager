# frozen_string_literal: true

require 'exchange/binance/client/options'
require 'exchange/binance/client/private'
require 'exchange/binance/client/public'

require 'exchange/binance/client/base'

module Exchange
  module Binance
    module Client
      def self.new(*args)
        Base.new(*args)
      end
    end
  end
end
