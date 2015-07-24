require 'bundler'
Bundler.require

require 'lib/stocks'

class App < Sinatra::Base
  # START:stockify
  post '/stockify' do
    # START:async
    response.headers["Transfer-Encoding"] = "chunked"
    async = env['java.servlet_request'].start_async
    # END:async

    # START:thread
    text = request.body.read.to_s
    Thread.new do
      sleep 5
      stocks = Stocks.parse_for_stocks(text)
      quotes = Stocks.get_quotes(stocks)
      new_text = Stocks.sub_quotes(text, quotes)
      async.response.output_stream.println("#{new_text}</div>")
      async.complete
    end
    # END:thread

    # START:start
    "<div>"
    # END:start
  end
  # END:stockify
end

run App
