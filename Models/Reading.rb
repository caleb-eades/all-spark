require 'active_record'

class Reading < ActiveRecord::Base
    belongs_to :portion
    has_many :verse, dependent: :destroy
end
