class AddColumnToAnswerEndQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :user_id, :integer, foreign_key: true
    add_column :questions, :user_id, :integer, foreign_key: true
  end
end
