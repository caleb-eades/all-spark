#!/usr/bin/env ruby

require 'date'
require 'hebruby'

class Parsha

    def parse(date)
        begin
            @dates = []
            @jul = Date.strptime(date,'%Y-%m-%d')
            @heb = Hebruby::HebrewDate.new(Date.new(@jul.year, @jul.month, @jul.day))
            getParsha
            return @parshaInfo
        rescue
            json = {"code" => 400, "message" => "Invalid Request", "reason" => "Invalid Date : #{date}. Must be in format '%Y-%m-%d'"}
            return json.to_json
        end
    end

    def getParsha
        @cycleYear = @heb.year
        @cycleStartDay = nil
        @lastWeeks = false

        shemeniAtzeret = Hebruby::HebrewDate.new(22,1,@heb.year)
        julian = Date.jd(shemeniAtzeret.jd)
        if (julian.saturday?)
            @cycleStartDay = 23;
        else
            @cycleStartDay = (22 - julian.wday)
        end

        if (shemeniAtzeret.day < @cycleStartDay)
            @cycleYear = @cycleYear - 1;
            @lastWeeks = true
        end
        setImportantDates
        setPortionNumber
    end

    def setPortionNumber
        days = Hebruby::HebrewDate.month_days(@heb.year,1) - @cycleStartDay
        if (@heb.month > 1)
            (2..@heb.month).each do |month|
                days = days + Hebruby::HebrewDate.month_days(@heb.year,month) 
            end
        end
        @weekOfYear = (days - (days % 7)) / 7
        
        @portionNumber = @weekOfYear - @offsetWeeks

        if (@lastWeeks)
            @portionNumber = (@weeksInYear - @offsetWeeks) + @weekOfYear 
        end

        if (@portionNumber < 0)
            @portionNumber = 0;
        end
        
        aliyah = @jul.wday
        aliyah += 1
        @parshaInfo = {"portion" => @portionNumber, "aliyah" => aliyah}
    end

    def setImportantDates

        isLeap = Hebruby::HebrewDate.leap?(@heb.year)

        # Rosh Hashana
        date = Hebruby::HebrewDate.new(1,1,@heb.year)
        dateObject = {"name" => "Rosh Hashana"}
        dateObject['date'] = date
        @dates.push(dateObject)

        julian = Date.jd(date.jd)
        if (julian.saturday?)
            @offsetWeeks = 5
        else
            @offsetWeeks = 4
        end

        # Yom Kippur
        dateObject = {"name" => "Yom Kippur"}
        dateObject['date'] = Hebruby::HebrewDate.new(1,10,@heb.year)
        @dates.push(dateObject)

        # Sukkot
        dateObject = {"name" => "Sukkot"}
        dateObject['date'] = Hebruby::HebrewDate.new(1,15,@heb.year)
        @dates.push(dateObject)

        # Shemini Atzeret
        dateObject = {"name" => "Shemini Atzeret"}
        dateObject['date'] = Hebruby::HebrewDate.new(1,22,@heb.year)
        @dates.push(dateObject)

        # Simchat Torah
        dateObject = {"name" => "Simchat Torah"}
        dateObject['date'] = Hebruby::HebrewDate.new(1,23,@heb.year)
        @dates.push(dateObject)

        # Pesach
        date = Hebruby::HebrewDate.new(isLeap ? 9 : 8,15,@heb.year)
        dateObject = {"name" => "Pesach"}
        dateObject['date'] = date
        @dates.push(dateObject)
        diff = 7 - (1 + Date.jd(date.jd).wday)

        # Pesach Shabbat
        dateObject = {"name" => "Pesach Shabbat"}
        dateObject['date'] = Hebruby::HebrewDate.new(isLeap ? 9 : 8,15 + diff,@heb.year)
        @dates.push(dateObject)

        # Pesach VII
        dateObject = {"name" => "Pesach VII"}
        dateObject['date'] = Hebruby::HebrewDate.new(isLeap ? 9 : 8,21 + diff,@heb.year)
        @dates.push(dateObject)

        # Pesach VIII
        dateObject = {"name" => "Pesach VIII"}
        dateObject['date'] = Hebruby::HebrewDate.new(isLeap ? 9 : 8,22 + diff,@heb.year)
        @dates.push(dateObject)

        # Shavuot
        dateObject = {"name" => "Shavuot"}
        dateObject['date'] = Hebruby::HebrewDate.new(10,6,@heb.year)
        @dates.push(dateObject)

        # Last Day of Year
        lastDay = nil
        if(isLeap)
            lastDay = Hebruby::HebrewDate.new(Hebruby::HebrewDate.month_days(@heb.year,12),12,@heb.year)
        else
            lastDay = Hebruby::HebrewDate.new(Hebruby::HebrewDate.month_days(@heb.year,12),12,@heb.year)
        end
        days = 0
        (1..lastDay.month).each do |month|
            days = days + Hebruby::HebrewDate.month_days(@heb.year,month)
        end
        @weeksInYear = (days - (days % 7)) / 7

    end
end

ARGV.each do |arg|
    parsha = Parsha.new(arg)
    puts parsha.getParsha
end
