class AddColumopeningToCandidate < ActiveRecord::Migration
  def change
     add_column :candidates, :openingname , :string 
     add_column :candidates, :openingid , :integer , :default => 0
  end
end
