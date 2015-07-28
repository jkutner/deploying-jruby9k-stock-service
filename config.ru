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
      begin
        puts "Thread(async): #{Thread.current.object_id}"
        stocks = Stocks.parse_for_stocks(text)
        quotes = Stocks.get_quotes(stocks)
        new_text = Stocks.sub_quotes(text, quotes)
        async.response.output_stream.println(new_text)
      ensure
        async.complete
      end
    end
    # END:thread

    # START:main_thread
    puts "Thread(main) : #{Thread.current.object_id}"
    # END:main_thread
  end
  # END:stockify
end

run App
