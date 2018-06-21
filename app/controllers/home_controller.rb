class HomeController < ApplicationController
  def index
    require 'net/http'
    require 'json'
    require 'mathn'
    
    if params[:id] == ""
      @nothing = "Hey, you forgot to enter the stock symbol"
    elsif
    
      if params[:id]
        begin
          @url_delayedquote = 'https://api.iextrading.com/1.0/stock/' + params[:id] + '/quote'
          @uri_delayedquote = URI(@url_delayedquote)
          @response_delayedquote = Net::HTTP.get(@uri_delayedquote)
          @stock_delayedquote = JSON.parse(@response_delayedquote)
          
          @url_companyinfo = 'https://api.iextrading.com/1.0/stock/' + params[:id] + '/company'
          @uri_companyinfo = URI(@url_companyinfo)
          @response_companyinfo = Net::HTTP.get(@uri_companyinfo)
          @stock_companyinfo = JSON.parse(@response_companyinfo)
          
          @url_3mchart = 'https://api.iextrading.com/1.0/stock/' + params[:id] + '/chart/3m'
          #https://api.iextrading.com/1.0/stock/aapl/chart/3m
          @uri_3mchart = URI(@url_3mchart)
          @response_3mchart = Net::HTTP.get(@uri_3mchart)
          @stock_3mchart = JSON.parse(@response_3mchart)
        
        rescue StandardError
          @error = "That Stock Symbol Doesn't Exist."
        end
      end 
    end
  end
  
  def about
  end

end
