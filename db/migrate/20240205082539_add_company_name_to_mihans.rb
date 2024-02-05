class AddCompanyNameToMihans < ActiveRecord::Migration[7.0]
  def change
    add_column :mihans, :company_name, :string
  end
end
