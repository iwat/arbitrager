# frozen_string_literal: true

module Exchange
  module Binance
    module Client
      module Public
        def market_data
          __public(nil)
        end

        alias ticker market_data

        def currency_pairings
          __public(:pairing)
        end

        def order_book(symbol = 'OMGETH')
          __public('v1/depth', symbol: symbol)
        end

        def recent_trades(pairing_id = 1)
          __public(:trade, pairing: pairing_id)
        end

        def trade_history(pairing_id = 1, date = Date.today)
          __public(:tradehistory, pairing: pairing_id, date: date.to_s)
        end
      end
    end
  end
end
