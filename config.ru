# frozen_string_literal: true

require './config/application'

Bitbot.instance.start

run(proc { |_env| ['200', { 'Content-Type' => 'text/html' }, ['get rack\'d']] })
