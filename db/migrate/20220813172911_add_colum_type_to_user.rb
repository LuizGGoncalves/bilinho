class AddColumTypeToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
    t.string :user_type, null: false, default:"Student"
    end
  end
end