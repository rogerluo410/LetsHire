class AddColumTooOpenings < ActiveRecord::Migration
  def up
     add_column :openings, :name , :string
     add_column :openings, :path , :string

  end

  def down
  end
end
