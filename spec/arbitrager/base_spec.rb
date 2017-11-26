# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Arbitrager::Base do
  let(:arbitrager) { Arbitrager::Base.new }

  describe '#register_exchange' do
    it 'adds supported pairing to the list' do
      expect(arbitrager.pairings.size).to eq(0)

      exchange_double('OMG/ETH').tap do |exchange|
        arbitrager.register_exchange(exchange)
      end
      expect(arbitrager.pairings).to include('OMG/ETH')

      exchange_double('ZRX/ETH').tap do |exchange|
        arbitrager.register_exchange(exchange)
      end

      expect(arbitrager.pairings).to include('OMG/ETH')
      expect(arbitrager.pairings).to include('ZRX/ETH')
    end
  end

  private

  def exchange_double(*pairings)
    instance_double('exchange', supported_pairings: pairings, setup: nil)
  end
end
