require 'bx_in_th_api'

module Arbitrager
  module Exchange
    class BxInTh
      attr_reader :bx
      def initialize
        @bx = ::BxInThAPI.new("", "")
      end
    end
  end
end
