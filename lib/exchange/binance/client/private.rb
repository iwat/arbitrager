# frozen_string_literal: true

module Exchange
  module Binance
    module Client
      module Private
        def create_order(pairing_id = 1, type = :buy, amount = 0, rate = 0)
          __private(:order, pairing: pairing_id, type: type, amount: amount, rate: rate)
        end

        def cancel_order(pairing_id = 1, order_ids = [])
          order_ids = [order_ids].flatten.join(',')
          raise 'No order ID specified!' if order_ids.strip.empty?
          __private(:cancel, pairing: pairing_id, order_id: order_ids)
        end

        def get_balance
          __private(:balance)
        end

        def get_orders(pairing_id = 1, type = :buy)
          __private(:getorders, pairing: pairing_id, type: type)
        end

        def history(currency = :BTC, type = :buy, start_date = nil, end_date = Time.now)
          start_date ||= end_date - 365 * 24 * 3600
          end_date   = end_date.strftime('%Y-%m-%d %H:%M:%S')
          start_date = start_date.strftime('%Y-%m-%d %H:%M:%S')
          __private(:history, currency: currency, type: type, start_date: start_date, end_date: end_date)
        end

        def deposit_address(currency = :BTC, new = false)
          __private(:deposit, currency: currency, new: new)
        end

        def request_withdrawal(address, currency = :BTC, amount = 0, bank_code = nil, account_name = nil)
          __private(:withdrawal, address: address, currency: currency, amount: amount, bank: bank_code, account_name: account_name)
        end

        def withdrawal_history
          __private('withdrawal-history')
        end
      end
    end
  end
end
