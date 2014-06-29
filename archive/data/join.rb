#!/usr/bin/env ruby

require 'json'

aliyot = JSON.parse(File.read(ARGV.shift))
verses = JSON.parse(File.read(ARGV.shift))

aliyot.each do |item|
    item['readings'].each do |reading|
        match = reading['range'].match(/(?<book>\w+) (?<startChapter>\d+):(?<startVerse>\d+) *- *(?<endChapter>\d+):(?<endVerse>\d+)/)
        unless(match == nil)
#            portionTexts = verses.select{|x| x['book'] == match['book']}
            portionTexts = verses.select{|x|
                x['book'] == match['book']}.select{|x|
                x['chapter'] >= match['startChapter']}.select{|x|
                x['chapter'] <= match['endChapter']
            }
            portionTexts.each do |portion|
                reading['verses'].push(portion)
            end
        end
    end
end

puts JSON.pretty_generate(aliyot)
