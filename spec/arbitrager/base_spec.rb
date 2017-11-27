# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Base do
  let(:arbitrager) { Arbitrager::Base.new }

  describe '#pairings' do
    it 'is initialed with empty list' do
      expect(arbitrager.pairings.size).to eq(0)
    end
  end
  describe '#register_exchange' do
    it 'adds supported pairing to the list' do
      exchange_double(['OMG/ETH']).tap do |exchange|
        arbitrager.register_exchange(exchange)
      end

      expect(arbitrager.pairings.size).to eq(1)
      expect(arbitrager.pairings).to include('OMG/ETH')

      exchange_double(['REQ/ETH', 'ZRX/ETH']).tap do |exchange|
        arbitrager.register_exchange(exchange)
      end

      expect(arbitrager.pairings.size).to eq(3)
      expect(arbitrager.pairings).to include('OMG/ETH')
      expect(arbitrager.pairings).to include('REQ/ETH')
      expect(arbitrager.pairings).to include('ZRX/ETH')
    end
  end

  describe '#find_opportunity' do
    before do
      exchange_double(['OMG/ETH']).tap do |exchange|
        arbitrager.register_exchange(exchange)
      end
    end
  end

  private

  def exchange_double(pairings, _price = nil)
    instance_double('exchange', supported_pairings: pairings, setup: nil)
  end
end
