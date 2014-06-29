#!/usr/bin/env ruby

require 'json'

class Parse
    def self.doAction(fileLocation)
        string = File.read(fileLocation)
        json = JSON.parse(string)
        output = []        

        json.each do |verse|
            hash = {}
            match = verse.match(/^(?<book>\w+) (?<chapter>\d+):(?<verse>\d+) (?<text>.*)$/)
            
            hash['book'] = match['book']
            hash['chapter'] = match['chapter']
            hash['verse'] = match['verse']
            hash['text'] = match['text']
            output.push(hash)
        end
        puts JSON.pretty_generate(output)
    end
end

Parse.doAction(ARGV.first)
