# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Exchange::Pairing do
  let(:omgeth) { Exchange::Pairing.new('OMG/ETH') }

  describe '#eq?' do
    let(:omgeth2) { Exchange::Pairing.new('OMG/ETH') }

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
    it 'returns slashed symbols' do
      expect(omgeth.to_s).to eq('OMG/ETH')
    end
  end
end
