require 'active_record'

class Verse < ActiveRecord::Base
    belongs_to :reading
end
