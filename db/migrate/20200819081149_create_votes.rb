class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :value, default: 0, null: false
      t.references :voteable, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
