# frozen_string_literal: true

require 'bx_in_th_api'

module Arbitrager
  module Exchange
    class BxInTh
      attr_reader :bx
      def initialize(api_key, secret)
        @bx = ::BxInThAPI.new(api_key, secret)
      end

      def setup
        bx.currency_pairings
      end
    end
  end
end
