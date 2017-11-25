# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Exchange::BxInTh do
  let(:bx) { Arbitrager::Exchange::BxInTh.new('apikey', 'secret') }

  before do
    stub_request(:get, 'https://bx.in.th/api/pairing/')
      .to_return(status: 200, body: <<~BODY, headers: {})
        {
          "21": { "pairing_id": 21, "primary_currency": "THB", "secondary_currency": "ETH" },
          "25": { "pairing_id": 25, "primary_currency": "THB", "secondary_currency": "XRP" },
          "26": { "pairing_id": 26, "primary_currency": "THB", "secondary_currency": "OMG" }
        }
    BODY
  end

  describe '#setup' do
    it 'does not crash' do
      bx.setup
    end
  end

  describe '#supported_pairings' do
    it 'supports OMG/ETH' do
      expect(bx.supported_pairings).to eq(['OMG/ETH'])
    end
  end

  describe '#opportunity' do
    before { bx.setup }

    before do
      stub_request(:get, 'https://bx.in.th/api/orderbook/?pairing=26')
        .to_return(status: 200, body: <<~BODY, headers: {})
          {
            "bids": [
              [ "265.56000000", "1.95078076" ],
              [ "265.55000000", "3.75635474" ],
              [ "265.51000000", "91.26991629" ],
              [ "265.50000000", "112.71186441" ],
              [ "265.11000000", "16.69110869" ]
            ],
            "asks": [
              [ "267.25000000", "0.92190305" ],
              [ "267.99000000", "20.00000000" ],
              [ "268.00000000", "117.30006058" ],
              [ "268.95000000", "50.00000000" ],
              [ "269.00000000", "12.00000000" ]
            ]
          }
        BODY
    end

    before do
      stub_request(:get, 'https://bx.in.th/api/orderbook/?pairing=21')
        .to_return(status: 200, body: <<~BODY, headers: {})
          {
            "bids": [
              [ "14819.00000000", "5.30763926" ],
              [ "14803.00000000", "0.77020639" ],
              [ "14803.00000000", "8.61940336" ],
              [ "14802.01000000", "0.56996014" ],
              [ "14802.00000000", "2.99116973" ]
            ],
            "asks": [
              [ "14869.00000000", "4.34050167" ],
              [ "14870.00000000", "0.33002196" ],
              [ "14870.00000000", "0.04253800" ],
              [ "14880.00000000", "2.70549231" ],
              [ "14889.00000000", "24.90855826" ]
            ]
          }
        BODY
    end

    it 'rejects bad pairing' do
      expect { bx.opportunity('BAD/BAD') }.to raise_error(ArgumentError)
    end

    it 'return opportunity object' do
      pp bx.opportunity('OMG/ETH')
    end
  end
end
