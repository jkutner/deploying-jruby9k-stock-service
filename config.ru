require 'bundler'
Bundler.require

require 'lib/stocks'

class App < Sinatra::Base
  post '/quotes' do
    response.headers["Transfer-Encoding"] = "chunked"
    async = env['java.servlet_request'].start_async

    Thread.new do
      stocks = Stocks.parse_for_stocks(request.body.read.to_s)
      quotes = Stocks.get_quotes(stocks).to_json

      async.response.output_stream.println(quotes.to_json)
      async.complete
    end
  end
end

run App
