require 'net/http'
require 'csv'

module Stocks

  ALL_NASDAQ_STOCKS = {
    "AAPL" => %r{Apple},
    "MSFT" => %r{Microsoft},
    "MU" => %r{Micron Technology},
    "INTC" => %r{Intel},
    "EBAY" => %r{eBay}
  }

  def self.parse_for_stocks(text)
    ALL_NASDAQ_STOCKS.keys.select.each do |symbol|
      ALL_NASDAQ_STOCKS[symbol] =~ text
    end
  end

  def self.get_quotes(stocks)
    unless stocks.empty?
      Net::HTTP.start("download.finance.yahoo.com") do |http|
        params = stocks.join("+")
        http.request_get("/d/quotes.csv?s=#{params}&f=nab") do |resp|
          return CSV.parse(resp.body)
        end
      end
    end
    return []
  end
end