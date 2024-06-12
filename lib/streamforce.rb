# frozen_string_literal: true

require_relative "streamforce/version"

require "uri"
require "net/http"
require "logger"
require "json"
require "base64"

require "faye"
require "relaxed_cookiejar"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

module Streamforce
end
