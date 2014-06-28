require 'json'

Dir["./Models/*.rb"].sort.each do |file| 
    file.sub!("\.rb","");
    require file
end

class VerseController
    public
    def self.create(data)
        verse = Verse.create( :verse => data['verse'], :portion_id => data['portion_id'] )

        verseJson = { :id => verse.id, :verse => verse.verse }

        return verseJson.to_json
    end

    def self.read(data)
        verse = Verse.find(data['id'])

        verseJson = { :id => verse.id, :verse => verse.verse }

        return verseJson.to_json

    end

    def self.update(data)
        verse = Verse.update( data['id'], :verse => data['verse'] )

        verseJson = { :id => verse.id, :verse => verse.verse }

        return verseJson.to_json

    end

    def self.delete(data)
        verse = Verse.find(data['id'])
        verse.destroy

        verseJson = { :id => verse.id, :verse => verse.verse }

        return verseJson.to_json

    end

    def self.list(data)
        verses = Verse.all

        Array verseJson = Array.new
        verses.each do |verse|
            verseJson.push({ :id => verse.id, :verse => verse.verse })
        end

        return verseJson.to_json

    end

    def self.recurse(portion_id, data)
        if(data.key?("Verse"))
            verses = Verse.where(:portion_id => portion_id) & self.filterData(data)
        else
            verses = Verse.where(:portion_id => portion_id)
        end

        Array verseJson = Array.new
        verses.each do |verse|
            verseJson.push({ :id => verse.id, :verse => verse.verse })
        end

        return verseJson

    end

    def self.filter(data)
        verses = self.filterData(data)

        count = verses.length

        page  = data['Verse']['pagination']['page'].to_i
        limit = data['Verse']['pagination']['limit'].to_i
 
        # Make sure page isn't out of range
        if(page < 1)
            page = 1
        end
 
        if(((page * limit) - limit) > count)
            page = (count / limit).to_i
            if(count % limit > 0)
                page += 1
            end
        end
 
        offset = (page - 1) * limit
        verses = verses.slice(offset, limit)

        Array verseJson = Array.new
        verses.each do |verse|
            verseJson.push({ :id => verse.id, :verse => verse.verse })
        end

        verseContainer = { :total => count, :verses => verseJson }

        return verseContainer.to_json

    end

    def self.filterData(data)

        verses = []
        if(data.key?("Verse"))
            filters = data['Verse']['filters']
            i = 0
            filters.each do |filter|
                filterName = filter["name"]
                filterValue = filter["value"]
                puts("filterName: #{filterName}")
                puts("filterValue: #{filterValue}")
                if(i == 0)
                    verses = Verse.where("#{filterName} LIKE '%#{filterValue}%'")
                else
                    verses = verses & Verse.where("#{filterName} LIKE '%#{filterValue}%'")
                end
                i += 1
            end
        end

        return verses
    end

end

