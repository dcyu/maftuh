class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :en_name
      t.string :ar_name

      t.timestamps
    end
  end
end
