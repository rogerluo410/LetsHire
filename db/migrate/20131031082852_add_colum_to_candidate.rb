class AddColumToCandidate < ActiveRecord::Migration
  def up
    add_column :candidates, :path , :string
  end
end
