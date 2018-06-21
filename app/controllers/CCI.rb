  def test
    require 'net/http'
    require 'json'
    require 'mathn'
    require 'descriptive_statistics'
    
    @para = "FB"
    
    if @para == ""
      @nothing = "Hey, you forgot to enter the stock symbol"
    elsif
    
      if @para
        @url_3mchart = 'https://api.iextrading.com/1.0/stock/' + @para + '/chart/3m'
        #https://api.iextrading.com/1.0/stock/aapl/chart/3m
        @uri_3mchart = URI(@url_3mchart)
        @response_3mchart = Net::HTTP.get(@uri_3mchart)
        @stock_3mchart = JSON.parse(@response_3mchart)
        
        @url_delayedquote = 'https://api.iextrading.com/1.0/stock/' + @para + '/delayed-quote'
        @uri_delayedquote = URI(@url_delayedquote)
        @response_delayedquote = Net::HTTP.get(@uri_delayedquote)
        @stock_todayquote = JSON.parse(@response_delayedquote)
      end
      
      @numberofdays = @stock_3mchart.count
      @ccidays = 20
      @lastitem = @stock_3mchart.count - 1
      
      @i = 0
      @ccidata = []
      @currentccidata = []
      
      loop do
        @typicalprice = (@stock_3mchart[@lastitem]['high'] + @stock_3mchart[@lastitem]['low'] + @stock_3mchart[@lastitem]['close'])/3
        @ccidata.push(@typicalprice)
        @currentccidata.push(@typicalprice)
        @i = @i + 1
        @lastitem = @lastitem - 1
        if @i == 20
          break       # this will cause execution to exit the loop
        end
      end
      @smadata = []
      @statisticsavg = @ccidata.mean
      @j = 0
      loop do
        @meandev = (@statisticsavg-@ccidata[@j]).abs
        @smadata.push(@meandev)
        @j = @j + 1
        @lastitem = @lastitem - 1
        if @j == 20
          break       # this will cause execution to exit the loop
        end
      end
      
      @cci = (@ccidata[0] - @ccidata.mean)/(0.015*@smadata.mean)
      
      @todaytypicalprice = (@stock_todayquote['high'] + @stock_todayquote['low'] + @stock_todayquote['delayedPrice'])/3
      
      @currentccidata.unshift(@todaytypicalprice)
      @currentccidata.pop
      puts @currentccidata
      puts @currentccidata.count
      
      puts @ccidata
      puts @ccidata.count
      puts @smadata.mean
      puts @smadata.count
      @average = @ccidata.inject{ |sum, el| sum + el }.to_f / @ccidata.size
      @statisticsavg = @ccidata.mean
      @statisticsSD = @ccidata.standard_deviation
      puts @statisticsavg
      puts @statisticsSD
      puts @average
      puts @ccidata[0]
      puts @ccidata.mean
      puts @cci
    end
  end
  
  test