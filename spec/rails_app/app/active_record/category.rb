require 'active_record'

class Category < ActiveRecord::Base
  def to_s
    name
  end
end
