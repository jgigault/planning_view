class Project < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :category
end

class Category < ActiveRecord::Base
end