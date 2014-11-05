class AddcolToopenings < ActiveRecord::Migration
  def up
    add_column :openings, :pass , :integer , :default => 0
    add_column :openings, :interview , :integer , :default => 0 
    add_column :openings, :fail , :integer , :default => 0
  end
end
