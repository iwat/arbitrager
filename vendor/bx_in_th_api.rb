require 'json'
require 'faraday'

require "bx_in_th_api/version"
require 'bx_in_th_api/public'
require 'bx_in_th_api/private'
require 'bx_in_th_api/options'
require 'bx_in_th_api/bill_payment'
require 'bx_in_th_api/base'

module BxInThAPI
  def self.new(*args)
    Base.new(*args)
  end
end
