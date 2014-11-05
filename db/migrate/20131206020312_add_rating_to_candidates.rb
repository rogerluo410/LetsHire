class AddRatingToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :rating, :float,:default => 0.0
  end
end
