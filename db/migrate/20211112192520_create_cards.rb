class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.string :suit
      t.string :value
      t.string :code
      t.string :full_value

      t.timestamps
    end
  end
end
