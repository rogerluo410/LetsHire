class AddToUsers < ActiveRecord::Migration
  def up
      add_column :users, :confirmation_token, :string 
      add_column :users, :confirmed_at, :datetime
      add_column :users, :confirmation_sent_at, :datetime
      add_column :users, :unconfirmed_email , :string
      add_column :users, :failed_attempts , :integer , :default => 0
      add_column :users, :unlock_token, :string 
      add_column :users, :reset_password_token, :string
      add_column :users, :reset_password_sent_at,:datetime 
      add_column :users, :locked_at , :datetime
      add_column :users, :current_sign_in_at , :datetime
      add_column :users, :last_sign_in_at , :datetime
      add_column :users, :current_sign_in_ip, :string
      add_column :users, :last_sign_in_ip, :string
      add_column :users, :sign_in_count, :integer

  end

  def down
  end
end
