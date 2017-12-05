# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Exchange::Pair do
  describe '#base' do
    let(:pair) { Exchange::Pair.new('OMG/THB/ETH') }

    it 'returns OMG' do
      expect(pair.base).to eq('OMG')
    end
  end

  describe '#quote' do
    let(:pair) { Exchange::Pair.new('OMG/THB/ETH') }

    it 'returns ETH' do
      expect(pair.quote).to eq('ETH')
    end
  end

  describe '#eq?' do
    let(:omgeth) { Exchange::Pair.new('OMG/ETH') }
    let(:omgeth2) { Exchange::Pair.new('OMG/ETH') }

    it 'supports equality' do
      expect(omgeth).to eq(omgeth2)
    end

    it 'is searchable in list' do
      expect([omgeth]).to include(omgeth2)
    end

    it 'is unique in set' do
      set = Set.new
      set.add(omgeth)
      set.add(omgeth2)

      expect(set.size).to eq(1)
      expect(set).to include(omgeth)
      expect(set).to include(omgeth2)
    end
  end

  describe '#to_s' do
    let(:omgeth) { Exchange::Pair.new('OMG/ETH') }

    it 'returns slashed symbols' do
      expect(omgeth.to_s).to eq('OMG/ETH')
    end
  end
end
