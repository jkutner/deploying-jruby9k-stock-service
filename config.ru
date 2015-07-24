require 'bundler'
Bundler.require

require 'lib/stocks'

class App < Sinatra::Base
  # START:stockify
  post '/stockify' do
    text = request.body.read.to_s
    stocks = Stocks.parse_for_stocks(text)
    quotes = Stocks.get_quotes(stocks)
    new_text = Stocks.sub_quotes(text, quotes)
  end
  # END:stockify
end

run App
