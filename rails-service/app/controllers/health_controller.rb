require 'net/http'
require 'uri'

class HealthController < ApplicationController
  def check
    render plain: 'OK'
  end

  def chain
    host = ENV.fetch('PYTHON_SERVICE_HOST')
    port = ENV.fetch('PYTHON_SERVICE_PORT')
    url = URI("http://#{host.strip}:#{port.strip}/chain")
    begin
      resp = Net::HTTP.get(url).force_encoding('UTF-8').scrub
      render plain: "Rails 1 Python → 1 Go: #{resp}"
    rescue => e
      render plain: "Error calling Python service: #{e}", status: 500
    end
  end
end
