class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :post
      t.references :user

      t.timestamps
    end
    add_index :votes, :post_id
    add_index :votes, :user_id
  end
end
