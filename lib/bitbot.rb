# frozen_string_literal: true

require 'bitbot/base'

module Bitbot
  def self.instance
    @@instance ||= Base.new
  end
end
