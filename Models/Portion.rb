require 'active_record'

class Portion < ActiveRecord::Base
    has_many :paragraph, dependent: :destroy
end
