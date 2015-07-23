require 'bundler'
Bundler.require

require 'lib/stocks'

class App < Sinatra::Base
  post '/stockify' do
    response.headers["Transfer-Encoding"] = "chunked"
    async = env['java.servlet_request'].start_async

    Thread.new do
      text = request.body.read.to_s
      stocks = Stocks.parse_for_stocks(text)
      quotes = Stocks.get_quotes(stocks)
      new_text = Stocks.sub_quotes(text, quotes)

      async.response.output_stream.println(new_text)
      async.complete
    end
  end
end

run App
