class AddCompanyToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :company, :string
  end
end
