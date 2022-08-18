class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :nome, unique: true, null: false
      t.string :cpf, unique: true, null: false
      t.date :data_nascimento
      t.integer :telefone
      t.string :genero, null: false
      t.string :meio_pagamento, null: false
      t.timestamps
    end
  end
end
