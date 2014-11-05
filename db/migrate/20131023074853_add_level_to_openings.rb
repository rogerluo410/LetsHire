class AddLevelToOpenings < ActiveRecord::Migration
  def change
    add_column :openings, :level, :string, :default => "MTS"
  end
end
