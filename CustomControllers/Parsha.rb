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
            findParshaNumber
            return {"portion" => @parshaNumber}
        rescue Exception => e  
            puts e.message  
            puts e.backtrace.inspect
            json = {"code" => 400, "message" => "Invalid Request", "detail" => "Invalid Date : #{date}. Must be in format '%Y-%m-%d'"}
            return json
        end
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
        @parshaNumber = ((@targetShabbat.jd - @workingShabbat.jd)/7)+1
        unless (@parshaNumber < 22)
            @parshaNumber = 21
            @workingShabbat = @workingShabbat + 147
            isLeapYear = Hebruby::HebrewDate.leap?(@simchatTorah.year)
            passoverStart = Hebruby::HebrewDate.new(15,1,@targetHebrew.year)
            while (@workingShabbat.jd <= @targetShabbat.jd)
                combined = false
                @workingShabbat = @workingShabbat + 7
                @parshaNumber = @parshaNumber + 1
                puts @parshaNumber
                case @parshaNumber
                    when 22
                        dayBeforePassover = passoverStart.jd - 1
                        days = dayBeforePassover - @workingShabbat.jd
                        weeks = (days - (days%7))/7
                        puts "days:#{days},weeks:#{weeks}"
                        if (weeks < 4)
                            combined = true
                        end
                    when 27,29
                        unless (isLeapYear)
                            combined = true
                        end
                    when 32
                        if (@inIsrael)
                            unless (isLeapYear)
                                date = Date.jd(passoverStart.jd)
                                if (!date.saturday?)
                                    combined = true
                                end
                            end
                        else
                            unless (isLeapYear)
                                combined = true
                            end
                        end
                    when 39
                        unless (@inIsrael)
                            date = Date.jd(passoverStart.jd)
                            if (date.thursday?)
                                combined = true
                            end
                        end
                    when 42
                        tishaBAv = Hebruby::HebrewDate.new(9,5,@workingShabbat.year)
                        days = tishaBAv.jd - @workingShabbat.jd
                        weeks = (days - (days%7))/7
                        if (weeks < 3)
                            combined = true
                        end
                    when 51
                        roshHashana = Hebruby::HebrewDate.new(1,1,@workingShabbat.year + 1)
                        days = roshHashana.jd - @workingShabbat.jd
                        if (days > 3)
                            combine = true
                        end
                end
                if(combined)
                    @parshaNumber = @parshaNumber + 1
                end
            end
            if (@parshaNumber > 54)
                @parshaNumber = 54
            elsif (@parshaNumber < 1)
                @parshaNumber = 1
            end
            if (combined)
                puts "PARSHA NUMBER = #{@parshaNumber}-#{@parshaNumber + 1}"
            else
                puts "PARSHA NUMBER = #{@parshaNumber}"
            end
        end
    end

end
