class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.string :status
      t.text :chat_history
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
