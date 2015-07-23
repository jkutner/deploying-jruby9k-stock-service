require 'sinatra'
require 'lib/stocks'

class App < Sinatra::Base

  get '/quotes' do
    response.headers["Transfer-Encoding"] = "chunked"
    async = env['java.servlet_request'].start_async

    Thread.new do
      stocks = Stocks.parse_for_stocks(text)
      quotes = Stocks.get_quotes(stocks)

      async.response.output_stream.println(quotes.to_json)
      async.complete
    end
  end
end

run App
