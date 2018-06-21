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
          
          
          @dayscount = @stock_3mchart.count
          @arrayitemnumberlastchange = @dayscount - 1
          @arrayitemnumber = @dayscount - 2
          @rsiperiod = 14
          @rsiperiodsmooth = @rsiperiod-1
          
          @rollingpositive = 0
          @numberofdayspositive = 0
          @rollingnegative = 0
          @numberofdaysnegative = 0
          @i = 0
          @lastpositivechange = 0
          @lastnegativechange = 0
          
          if @stock_3mchart[@arrayitemnumberlastchange]['change'].to_f > 0
            @lastpositivechange = @stock_3mchart[@arrayitemnumberlastchange]['change'].to_f
          elsif @stock_3mchart[@arrayitemnumberlastchange]['change'].to_f <= 0
            @lastnegativechange = @stock_3mchart[@arrayitemnumberlastchange]['change'].to_f
          end
            
         
          while @i < @rsiperiodsmooth do
            @stock_3mchartnumber = @stock_3mchart[@arrayitemnumber]['change'].to_f 
            if @stock_3mchartnumber > 0
              @rollingpositive = @rollingpositive + @stock_3mchartnumber
              @numberofdayspositive = @numberofdayspositive + 1
            elsif @stock_3mchartnumber < 0
              @rollingnegative = @rollingnegative + @stock_3mchartnumber
              @numberofdaysnegative = @numberofdaysnegative + 1
            end
            @arrayitemnumber -= 1
            @i += 1
          end
          
          @postiveaverage = ((1/@rsiperiod) * @lastpositivechange) + (@rollingpositive * (@rsiperiodsmooth/@rsiperiod))
          @negativeaverage = ((1/@rsiperiod) * @lastnegativechange) + (@rollingnegative * (@rsiperiodsmooth/@rsiperiod))
          
          @avggainloss3m = @postiveaverage/(-1 * @negativeaverage)
          @rsi14 = (100 - (100/(1+@avggainloss3m))).round(2) 
        
        rescue StandardError
          @error = "That Stock Symbol Doesn't Exist."
        end
      end 
    end
  end
  
  def about
  end

end
