# frozen_string_literal: true

module Exchange
  module Binance
    module Client
      module Private
        def create_order(symbol, side = :BUY, quantity = 0, price = 0)
          __private('v3/order/test', :post, symbol: symbol, side: side, type: 'LIMIT', quantity: quantity, timeInForce: 'GTC', price: price)
        end

        def cancel_order(symbol, order_id)
          __private('v3/order', :delete, symbol: symbol, orderId: order_id)
        end

        def get_account
          __private('v3/account', :get)
        end

        def get_orders(symbol)
          __private('v3/allOrders', :get, symbol: symbol)
        end

        def history(symbol)
          __private('v3/myTrades', :get, symbol: symbol)
        end

        def deposit_address(asset)
          __private('/wapi/v3/depositAddress.html', :get, asset: asset)
        end

        def deposit_history
          __private('/wapi/v3/depositHistory.html', :get)
        end

        def request_withdrawal(address, asset, _amount)
          __private('/wapi/v3/withdraw.html', :post, asset: asset, address: address, amount: amoount)
        end

        def withdrawal_history
          __private('/wapi/v3/withdrawHistory.html', :get)
        end
      end
    end
  end
end
