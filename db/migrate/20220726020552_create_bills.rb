class CreateBills < ActiveRecord::Migration[6.1]
  def change
    create_table :bills do |t|
      t.float :valor_fatura, null: false
      t.date :data_vencimento, null: false
      t.string :status, null: false
      t.timestamps
    end
    add_reference :bills, :registration, null: false, foreign_key: true
  end
end
