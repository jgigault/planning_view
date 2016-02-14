ActiveRecord::Schema.define do
  self.verbose = false

  create_table :projects, :force => true do |t|
    t.string :name
    t.integer :category_id
    t.datetime :negotiation_start
    t.datetime :negotiation_end
  end

  create_table :categories, :force => true do |t|
    t.string :name
  end

end