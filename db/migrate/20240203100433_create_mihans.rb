class CreateMihans < ActiveRecord::Migration[7.0]
  def change
    create_table :mihans do |t|
      t.string :foreigners_in_excel_not_in_csv
      t.string :foreigners_without_residence
      t.string :saudis_only_in_csv
      t.string :saudis_in_excel_not_in_csv
      t.string :saudis_in_both_files_half
      t.string :saudis_in_both_files_zero

      t.timestamps
    end
  end
end
