require 'active_record'

class Portion < ActiveRecord::Base
    has_many :reading, dependent: :destroy
end
