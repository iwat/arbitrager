# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Base do
  let(:arbitrager) { Arbitrager::Base.new }
  let(:omgeth) { Exchange::Pair.new('OMG/ETH') }

  describe '#pairs' do
    it 'is initialed with empty list' do
      expect(arbitrager.pairs.size).to eq(0)
    end
  end

  describe '#register_exchange' do
    let(:reqeth) { Exchange::Pair.new('REQ/ETH') }
    let(:zrxeth) { Exchange::Pair.new('ZRX/ETH') }

    it 'adds supported pair to the list' do
      arbitrager.register_exchange(exchange_double([omgeth]))

      expect(arbitrager.pairs.size).to eq(1)
      expect(arbitrager.pairs).to include(omgeth)

      arbitrager.register_exchange(exchange_double([reqeth, zrxeth]))

      expect(arbitrager.pairs.size).to eq(3)
      expect(arbitrager.pairs).to include(omgeth)
      expect(arbitrager.pairs).to include(reqeth)
      expect(arbitrager.pairs).to include(zrxeth)
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

  def exchange_double(pairs, price = nil)
    instance_double(
      'exchange',
      supported_pairs: pairs,
      setup: nil,
      fetch_price: price
    )
  end
end
