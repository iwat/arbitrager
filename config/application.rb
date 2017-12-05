# frozen_string_literal: true

require File.expand_path('../boot', __FILE__)

require 'dotenv'

Dotenv.load(".env.#{ENV['RACK_ENV']}.local", '.env.local', ".env.#{ENV['RACK_ENV']}", '.env')

require 'arbitrager'
require 'bitbot'
require 'exchange'
