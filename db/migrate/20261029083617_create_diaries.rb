class CreateDiaries < ActiveRecord::Migration[8.1]
  def change
    create_table :diaries do |t|
      t.date :date, null: false
      t.string :location, null: false
      t.string :image
      t.text :body
      
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
