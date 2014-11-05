class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :opening_candidate_id
      t.decimal :english
      t.decimal :relevance
      t.decimal :smart
      t.decimal :programming
      t.decimal :computerscience
      t.decimal :systems
      t.decimal :fit
      t.decimal :motivation
      t.string :comment
      t.integer :ext1
      t.integer :ext2
      t.string :ext3

      t.timestamps
    end
   add_index :comments, :opening_candidate_id
  end
end
