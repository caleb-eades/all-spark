#!/usr/bin/env ruby

require 'date'
require 'hebruby'

class Parsha

    def parse(date)
        begin
            @dates = []
            @jul = Date.strptime(date,'%Y-%m-%d')
            @heb = Hebruby::HebrewDate.new(Date.new(@jul.year, @jul.month, @jul.day))
            #getParsha
        rescue
            json = {"code" => 400, "message" => "Invalid Request", "reason" => "Invalid Date : #{date}. Must be in format '%Y-%m-%d'"}
            return json
        end
        setParshaInfo
        return @parshaInfo
    end

    def setParshaInfo
        @beforeSA = false
        @cycleYear = @heb.year
        @cycleStartDay = 22
    
        # Set the date of Shemeni Atzeret
        setSA

        # If it is before Shemeni Atzeret, use previous year
        if (@heb.month < 7 || (@heb.month == 7 && @heb.day < @cycleStartDay))
            @cycleYear = @cycleYear - 1;
            @beforeSA = true
            setSA
        end

        # Figure out How many weeks into the cycle we are
        days = 0
        if (@beforeSA)
            days += @heb.day
            # All days in previous year since SA
            days = days + Hebruby::HebrewDate.month_days(@hebrewSA.year, @hebrewSA.month)
            days = days - @hebrewSA.day
            (8..Hebruby::HebrewDate.year_months(@cycleYear)).each do |month|
                days = days + Hebruby::HebrewDate.month_days(@heb.year,month)
            end
            # All days in Year to date
            if (@heb.month != 1)
                (1..@heb.month - 1).each do |month|
                    days = days + Hebruby::HebrewDate.month_days(@heb.year,month)
                end
            end
        else
            # Days of current Month + days after SA in Tishrei
            days = days + @heb.day
            days = days - @hebrewSA.day
            if (@heb.month > 7)
                days = days + Hebruby::HebrewDate.month_days(@hebrewSA.year, @hebrewSA.month)
            end
            # All the months in between
            if (@heb.month != 8)
                (8..@heb.month - 1).each do |month|
                    days = days + Hebruby::HebrewDate.month_days(@heb.year,month)
                end
            end
        end
        # Calculate weeks from days
        @weekOfCycle = ((days - (days % 7)) / 7) + 1
        aliyah = @jul.wday
        aliyah += 1
        @parshaInfo = {"portion" => @weekOfCycle, "aliyah" => aliyah}
    end

    def setSA
        @hebrewSA = Hebruby::HebrewDate.new(@cycleStartDay,7,@cycleYear)
        @julianSA = Date.jd(@hebrewSA.jd)

        if (!@julianSA.saturday?)
            @cycleStartDay = @cycleStartDay + (6 - @julianSA.wday)
        end
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
