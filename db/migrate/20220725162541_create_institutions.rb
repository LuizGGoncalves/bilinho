class CreateInstitutions < ActiveRecord::Migration[6.1]
  def change
    create_table :institutions do |t|
      t.string :nome, null: false, unique: true
      t.string :cnpj, null: false, unique: true
      t.string :tipo, null: false
      t.timestamps
    end
  end
end
