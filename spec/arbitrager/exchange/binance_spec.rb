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
    it 'supports OMG/ETH' do
      expect(exchange.supported_pairings).to eq(['OMG/ETH'])
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
    end

    it 'rejects bad pairing' do
      expect { exchange.fetch_price('BAD/BAD') }.to raise_error(ArgumentError)
    end

    it 'return fetch_price object' do
      pp exchange.fetch_price('OMG/ETH')
    end
  end
end
