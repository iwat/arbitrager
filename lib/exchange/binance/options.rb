# frozen_string_literal: true

module Exchange
  module Binance
    module Options
      def available_options(pairing_id = 1, date = nil)
        __public(:options, pairing: pairing_id, date: date)
      end

      def options_orderbook(option_id)
        __public(:optionbook, option_id: option_id)
      end

      def issue_option(strike, volume, ask, expiry, qty = 1, pairing_id = 1, type = :call)
        __private('option-issue', pairing: pairing_id, type: type, strike: strike,
                                  volume: volume, ask: ask, expiry: expiry, qty: qty)
      end

      def bid_on_option(option_id, bid, qty = 1, fill_or_kill = false)
        __private('option-bid', option_id: option_id, bid: bid, qty: qty, fill_or_kill: fill_or_kill)
      end

      def sell_on_option(option_id, ask)
        __private('option-sell', option_id: option_id, ask: ask)
      end

      def my_option_issues(pairing_id = 1, expire = nil, type = :call)
        __private('option-myissue', pairing: pairing_id, expire: expire, type: type)
      end

      def my_option_bids(pairing_id = 1, expire = nil, type = :call)
        __private('option-mybid', pairing: pairing_id, expire: expire, type: type)
      end

      def my_options(pairing_id = 1, expire = nil, type = :call)
        __private('option-myoptions', pairing: pairing_id, expire: expire, type: type)
      end

      def exercise_option(option_id)
        __private('option-exercise', option_id: option_id)
      end

      def cancel_option(option_id)
        __private('option-cancel', option_id: option_id)
      end

      def option_history(pairing_id = 1)
        __private('option-history', pairing: pairing_id)
      end
    end
  end
end
