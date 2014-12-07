class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.string :en_name
      t.string :ar_name
      t.string :lat
      t.string :lng
      t.text :en_description
      t.text :ar_description
      t.boolean :open
      t.integer :district_id
      t.timestamps
    end
  end
end
