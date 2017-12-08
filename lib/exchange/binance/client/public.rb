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

        def klines(symbol = 'BTCUSDT', interval = '1h', range: (Time.now - 86_400..Time.now))
          __public(
            'v1/klines',
            symbol: symbol,
            interval: interval,
            startTime: range.first.to_i * 1000,
            endTime: range.last.to_i * 1000
          )
        end

        def order_book(symbol)
          __public('v1/depth', symbol: symbol)
        end

        def recent_trades(_pairing_id = 1)
          __public('v1/aggTrades', symbol: symbol)
        end

        def trade_history(pairing_id = 1, date = Date.today)
          __public(:tradehistory, pairing: pairing_id, date: date.to_s)
        end
      end
    end
  end
end
