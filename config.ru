# frozen_string_literal: true

require './config/boot'

require 'bitbot'

Bitbot.new.dispatch

run Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['get rack\'d']] }
