require 'bundler'
Bundler.require

require 'lib/stocks'

class App < Sinatra::Base
  post '/quotes' do
    content_type :json
    stocks = Stocks.parse_for_stocks(request.body.read.to_s)
    Stocks.get_quotes(stocks).to_json
  end
end

run App
