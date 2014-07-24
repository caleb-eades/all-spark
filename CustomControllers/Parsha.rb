#!/usr/bin/env ruby

require 'date'
require 'hebruby'

class Parsha

    attr_accessor :targetShabbat  # Date
    attr_accessor :targetHebrew   # Hebruby
    attr_accessor :simchatTorah   # Date
    attr_accessor :workingShabbat # Date
    attr_accessor :inIsrael       # Boolean
    attr_accessor :parshaNumber   # Integer

    def getParsha(date)
        begin
            @targetShabbat = Date.strptime(date,'%Y-%m-%d')
            @targetShabbat = @targetShabbat + (6 - @targetShabbat.wday)
            @targetHebrew = Hebruby::HebrewDate.new(@targetShabbat)
            @inIsrael = false
            findSimchatTorah
            findYomTovim
            findParshaNumber
        rescue Exception => e  
            puts e.message  
            puts e.backtrace.inspect
            json = {"code" => 400, "message" => "Invalid Request", "detail" => "Invalid Date : #{date}. Must be in format '%Y-%m-%d'"}
        end
        return {}
    end

    def findSimchatTorah
        if (@inIsrael)
            @simchatTorah = Hebruby::HebrewDate.new(22,7,@targetHebrew.year)
        else
            @simchatTorah = Hebruby::HebrewDate.new(23,7,@targetHebrew.year)
        end 
        if (@simchatTorah.jd > @targetHebrew.jd)
            if (@inIsrael)
                @simchatTorah = Hebruby::HebrewDate.new(22,7,@targetHebrew.year - 1)
            else
                @simchatTorah = Hebruby::HebrewDate.new(23,7,@targetHebrew.year - 1)
            end 
        end
        @simchatTorah = Date.jd(@simchatTorah.jd)
        @workingShabbat = @simchatTorah + (6 - @simchatTorah.wday)
    end

    def findParshaNumber
        @parshaNumber = (@targetShabbat - @workingShabbat)/7
        unless (@parshaNumber < 22)
            @parshaNumber = 21
            @workingShabbat = @workingShabbat + 147
            isLeapYear = Hebruby::HebrewDate.leap?(@simchatTorah.year)
            passoverStart = Hebruby::HebrewDate.new(15,1,@targetHebrew.year)
            if (passoverStart.jd > @targetShabbat.jd)
                passoverStart = Hebruby::HebrewDate.new(15,1,@targetHebrew.year + 1)
            end
            while (@workingShabbat.jd <= @targetShabbat.jd)
                combined = false
                # Iterate
                @workingShabbat = @workingShabbat + 7
                if(combined)
                    @parshaNumber = @parshaNumber + 2
                else
                    @parshaNumber = @parshaNumber + 1
                end
            end
            puts "PARSHA NUMBER = #{@parshaNumber}"
        end
    end

    def findYomTovim

    end

end
