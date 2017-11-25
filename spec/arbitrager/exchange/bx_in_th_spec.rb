# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Exchange::BxInTh do
  let(:bx) { Arbitrager::Exchange::BxInTh.new('apikey', 'secret') }

  describe '#setup' do
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

    it 'does not crash' do
      bx.setup
    end
  end
end
