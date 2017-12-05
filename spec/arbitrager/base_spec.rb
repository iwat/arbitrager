# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Base do
  let(:arbitrager) { Arbitrager::Base.new }
  let(:omgeth) { Exchange::Pairing.new('OMG/ETH') }

  describe '#pairings' do
    it 'is initialed with empty list' do
      expect(arbitrager.pairings.size).to eq(0)
    end
  end

  describe '#register_exchange' do
    let(:reqeth) { Exchange::Pairing.new('REQ/ETH') }
    let(:zrxeth) { Exchange::Pairing.new('ZRX/ETH') }

    it 'adds supported pairing to the list' do
      arbitrager.register_exchange(exchange_double([omgeth]))

      expect(arbitrager.pairings.size).to eq(1)
      expect(arbitrager.pairings).to include(omgeth)

      arbitrager.register_exchange(exchange_double([reqeth, zrxeth]))

      expect(arbitrager.pairings.size).to eq(3)
      expect(arbitrager.pairings).to include(omgeth)
      expect(arbitrager.pairings).to include(reqeth)
      expect(arbitrager.pairings).to include(zrxeth)
    end
  end

  describe '#find_opportunity' do
    before do
      arbitrager.register_exchange(exchange_double([omgeth], [0.1, 0.2]))
      arbitrager.register_exchange(exchange_double([omgeth], [0.3, 0.4]))
    end

    it 'returns opportunity' do
      arbitrager.find_opportunity
    end
  end

  private

  def exchange_double(pairings, price = nil)
    instance_double(
      'exchange',
      supported_pairings: pairings,
      setup: nil,
      fetch_price: price
    )
  end
end
