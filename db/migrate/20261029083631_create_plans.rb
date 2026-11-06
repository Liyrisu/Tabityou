class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.date :date, null: false
      t.string :location, null: false
      t.string :image
      t.text :comment

      t.references :user, foreign_key: true

      t.timestamps
    end

    # diaries テーブルに対して、plan への紐付けを追加する
    add_reference :diaries, :plan, foreign_key: true
  end
end
