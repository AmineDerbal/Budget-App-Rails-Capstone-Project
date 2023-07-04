class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :icon
      t.integer :author_id

      t.timestamps
    end
    add_foreign_key :groups, :users, column: :author_id
    add_index :groups, :author_id
  end
end
