class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.string :task
      t.integer :user_id
      t.string :body

      t.datetime :created_at
    end
  end
end
