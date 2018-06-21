  def test
    require 'net/http'
    require 'json'
    require 'mathn'
    
    #@value = "aapl"
    #@url = 'https://api.iextrading.com/1.0/stock/' + @value + '/delayed-quote'
    #https://api.iextrading.com/1.0/stock/aapl/delayed-quote
    #@uri = URI(@url)
    #@response = Net::HTTP.get(@uri)
    #@stock = JSON.parse(@response)
    
    @para = "FB"
    
    if @para == ""
      @nothing = "Hey, you forgot to enter the stock symbol"
    elsif
    
      if @para
        @url_delayedquote = 'https://api.iextrading.com/1.0/stock/' + @para + '/delayed-quote'
        @uri_delayedquote = URI(@url_delayedquote)
        @response_delayedquote = Net::HTTP.get(@uri_delayedquote)
        @stock_delayedquote = JSON.parse(@response_delayedquote)
        
        @url_companyinfo = 'https://api.iextrading.com/1.0/stock/' + @para + '/company'
        @uri_companyinfo = URI(@url_companyinfo)
        @response_companyinfo = Net::HTTP.get(@uri_companyinfo)
        @stock_companyinfo = JSON.parse(@response_companyinfo)
        
        @url_3mchart = 'https://api.iextrading.com/1.0/stock/' + @para + '/chart/3m'
        #https://api.iextrading.com/1.0/stock/aapl/chart/3m
        @uri_3mchart = URI(@url_3mchart)
        @response_3mchart = Net::HTTP.get(@uri_3mchart)
        @stock_3mchart = JSON.parse(@response_3mchart)
        
        
        @chartdayscount = @stock_3mchart.count
        @arrayitemnumberlastchange = @chartdayscount - 1
        @arrayitemnumber = @chartdayscount - 2
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
          
       
        while @i < @rsiperiod do
          @stock_3mchartnumber = @stock_3mchart[@i]['change'].to_f 
          if @stock_3mchartnumber > 0
            @rollingpositive = @rollingpositive + @stock_3mchartnumber
            @numberofdayspositive = @numberofdayspositive + 1
          elsif @stock_3mchartnumber < 0
            @rollingnegative = @rollingnegative + (-1* @stock_3mchartnumber)
            @numberofdaysnegative = @numberofdaysnegative + 1
          end
          @i += 1
        end
        
        @rollingpositiveaverage = @rollingpositive.round(2)/@rsiperiod
        @rollingnegativeaverage = @rollingnegative.round(2)/@rsiperiod
        @rollingrs = @rollingpositiveaverage.round(2)/@rollingnegativeaverage.round(2)
        @rsi14 = (100 - (100/(1+@rollingrs))).round(2)
        
        puts @rollingpositiveaverage.round(2)
        puts @rollingnegativeaverage.round(2)
        puts @rollingrs.round(2)
        puts @rsi14.round(2)
        puts @i
        puts @chartdayscount
        
        @i = @i+1
        
        while @i < @chartdayscount do
          @stock_3mchartnumber = @stock_3mchart[@i]['change'].to_f 
          if @stock_3mchartnumber > 0
            @positivechange = @stock_3mchartnumber
            @negativechange = 0
            #@rollingpositiveaverage = (@rollingpositiveaverage.round(2)*(@rsiperiod-1)+@stock_3mchartnumber)/@rsiperiod
            #@numberofdayspositive = @numberofdayspositive + 1
            puts @stock_3mchartnumber
          elsif @stock_3mchartnumber < 0
            @positivechange = 0
            @negativechange = @stock_3mchartnumber
            #@rollingnegativeaverge = (@rollingpositiveaverage.round(2)*(@rsiperiod-1)+(-1 * @stock_3mchartnumber))/@rsiperiod
            #@numberofdaysnegative = @numberofdaysnegative + 1
          end
          @rollingpositiveaverage = (@rollingpositiveaverage.round(2)*(@rsiperiod-1)+@positivechange)/@rsiperiod
          @rollingnegativeaverge = (@rollingpositiveaverage.round(2)*(@rsiperiod-1)+(-1 * @negativechange))/@rsiperiod
          @i += 1
          @rollingrs = @rollingpositiveaverage.round(2)/@rollingnegativeaverage.round(2)
          @rsi14 = (100 - (100/(1+@rollingrs))).round(2)
          puts @rollingpositiveaverage.round(2)
          puts @rollingnegativeaverage.round(2)
          puts @rollingrs.round(2)
          puts @rsi14
        end
        puts @rsi14
      end 
    end
  end
  
  test