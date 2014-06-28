require 'active_record'

class Portion < ActiveRecord::Base
    has_many :verse, dependent: :destroy
end
