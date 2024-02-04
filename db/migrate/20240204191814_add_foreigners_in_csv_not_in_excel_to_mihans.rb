class AddForeignersInCsvNotInExcelToMihans < ActiveRecord::Migration[7.0]
  def change
    add_column :mihans, :foreigners_in_csv_not_in_excel, :string
  end
end
