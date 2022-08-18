class CreateRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :registrations do |t|
      t.float :valor_total, null: false
      t.integer :quantidade_faturas, null: false
      t.integer :vencimento, null: false
      t.string :nome_curso, null: false
      t.timestamps
    end
    add_reference :registrations, :student, null: false, foreign_key: true
    add_reference :registrations, :institution, null: false, foreign_key: true
  end
end
