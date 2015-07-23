require 'bundler'
Bundler.require

require 'lib/stocks'

class App < Sinatra::Base
  post '/quotes' do
    text = request.body.read.to_s
    stocks = Stocks.parse_for_stocks(text)
    quotes = Stocks.get_quotes(stocks)
    Stocks.sub_quotes(text, quotes)
  end
end

run App
