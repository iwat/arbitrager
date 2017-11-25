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
        pairings = bx.currency_pairings
        @omg_thb = pairings.find { |_, pair| match_pair(pair, 'THB', 'OMG') }
        @eth_thb = pairings.find { |_, pair| match_pair(pair, 'THB', 'ETH') }
      end

      def supported_pairings
        ['OMG/ETH'].freeze
      end

      private

      def match_pair(pair, pri, sec)
        pair['primary_currency'] == pri && pair['secondary_currency'] == sec
      end
    end
  end
end
