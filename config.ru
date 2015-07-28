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

    text = request.body.read.to_s
    # START:thread_submit
    settings.thread_pool.submit do
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
    # END:thread_submit

    # START:main_thread
    puts "Thread(main) : #{Thread.current.object_id}"
    # END:main_thread
  end
  # END:stockify
end

# START:thread_pool
thread_pool = JRuby::Executors.new_cached_thread_pool
App.set :thread_pool, thread_pool
# at_exit { thread_pool.shutdown }
# END:thread_pool

run App
