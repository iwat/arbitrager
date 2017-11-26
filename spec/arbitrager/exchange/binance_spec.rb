# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Exchange::Binance do
  let(:exchange) { Arbitrager::Exchange::Binance.new('apikey', 'secret') }

  describe '#setup' do
    it 'does not crash' do
      exchange.setup
    end
  end

  describe '#supported_pairings' do
    %w[
      KNC/BTC/USDT KNC/ETH/USDT
      OMG/ETH
      OMG/BTC/USDT OMG/ETH/USDT
      REQ/BTC/USDT REQ/ETH/USDT
      ZRX/BTC/USDT ZRX/ETH/USDT
    ].each do |symbol|
      it "supports #{symbol}" do
        expect(exchange.supported_pairings).to include(symbol)
      end
    end
  end

  describe '#fetch_price' do
    before { exchange.setup }

    before do
      stub_request(:get, 'https://api.binance.com/api/v1/depth?symbol=OMGETH')
        .to_return(status: 200, body: <<~BODY, headers: {})
          {
            "lastUpdateId": 5491554,
            "bids": [
              [ "0.01829300", "90.90000000", [] ],
              [ "0.01816800", "13.45000000", [] ],
              [ "0.01810900", "16.49000000", [] ],
              [ "0.01810800", "509.19000000", [] ],
              [ "0.01801200", "12.44000000", [] ]
            ],
            "asks": [
              [ "0.01845600", "731.34000000", [] ],
              [ "0.01861700", "775.24000000", [] ],
              [ "0.01861900", "0.76000000", [] ],
              [ "0.01864000", "1.00000000", [] ],
              [ "0.01864900", "0.76000000", [] ]
            ]
          }
        BODY

      stub_request(:get, 'https://api.binance.com/api/v1/depth?symbol=ETHUSDT')
        .to_return(status: 200, body: <<~BODY, headers: {})
          {
            "lastUpdateId": 8704083,
            "bids": [
              [ "457.26000000", "2.10298000", [] ],
              [ "456.93000000", "4.99000000", [] ],
              [ "456.92000000", "0.11952000", [] ],
              [ "455.06000000", "2.34490000", [] ],
              [ "455.00000000", "2.79352000", [] ]
            ],
            "asks": [
              [ "457.39000000", "0.03000000", [] ],
              [ "457.40000000", "0.65018000", [] ],
              [ "457.48000000", "0.22500000", [] ],
              [ "461.74000000", "4.27000000", [] ],
              [ "461.75000000", "2.88069000", [] ]
            ]
          }
        BODY
    end

    it 'rejects bad pairing' do
      expect { exchange.fetch_price('BAD/BAD') }.to raise_error(ArgumentError)
    end

    it 'returns fetch_price object' do
      pp exchange.fetch_price('OMG/ETH')
    end

    it 'calculates multi symbol pricing' do
      pp exchange.fetch_price('OMG/ETH/USDT')
    end
  end
end
