# frozen_string_literal: true

require 'bx_in_th_api'

module Arbitrager
  module Exchange
    class BxInTh
      attr_reader :bx
      def initialize
        @bx = ::BxInThAPI.new('', '')
      end

      def setup
        bx.currency_pairings
      end
    end
  end
end
