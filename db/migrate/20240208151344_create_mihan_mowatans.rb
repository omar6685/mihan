class CreateMihanMowatans < ActiveRecord::Migration[7.0]
  def change
    create_table :mihan_mowatans do |t|
      t.string :result
      t.string :company_name

      t.timestamps
    end
  end
end
