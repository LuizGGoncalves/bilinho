class AddRoleToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
    t.text :roles, array: true, default:[]
    end
  end
end
