ActiveRecord::Schema.define(:version => 1) do

  create_table "comments", :force => true do |t|
    t.string :author
  end
  
  create_table "users", :force => true do |t|
    t.string :name
  end

  create_table "people", :force => true do |t|
    t.string :first_name
    t.string :last_name
  end

  create_table "posts", :force => true do |t|
    t.string :title
    t.datetime :published_at
    t.boolean :draft, :default => true
  end

  create_table "sales", :force => true do |t|
    t.datetime :ordered_at
  end

  create_table "notes", :force => true do |t|
    t.integer :clicked
    t.datetime :published_at
    t.date :expire_at
    t.boolean :active
    t.float :points
  end
end