class CreateAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :associations do |t|
      t.references :user, null: false, polymorphic: true
      t.references :associationable, null: false, polymorphic: true, index: {name: "index_assoc_on_type_and_id"}

      t.timestamps
    end
  end
end