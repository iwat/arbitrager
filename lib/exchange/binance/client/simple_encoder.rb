# frozen_string_literal: true

require 'openssl'

module Exchange
  module Binance
    module Client
      class SimpleEncoder
        def encode(params)
          URI.encode_www_form(params)
        end
      end
    end
  end
end
