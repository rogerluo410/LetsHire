class AddStateToInterviewers < ActiveRecord::Migration
  def change
    add_column :interviewers, :state, :integer, :default => 0
  end
end
