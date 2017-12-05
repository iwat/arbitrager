# frozen_string_literal: true

module Exchange
  class Pair
    attr_reader :symbols

    def initialize(symbols)
      @symbols = symbols.split('/')
    end

    def base
      symbols.first
    end

    def hash
      symbols.hash
    end

    def quote
      symbols.last
    end

    def sub_pairs
      symbols
        .zip(symbols[1..-1])
        .reject { |pair| pair[1].nil? }
        .map { |pair| Pair.new(pair.join('/')) }
    end

    # Object

    def ==(other)
      self.class == other.class && symbols == other.symbols
    end

    def eql?(other)
      self.class == other.class && symbols == other.symbols
    end

    def inspect
      "#{self.class}:#{self}"
    end

    def to_s
      symbols.join('/')
    end
  end
end
