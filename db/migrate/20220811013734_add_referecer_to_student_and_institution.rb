class AddReferecerToStudentAndInstitution < ActiveRecord::Migration[6.1]
  def change
    add_reference :institutions, :user, null: true, foreign_key: true
    add_reference :students, :user, null: true, foreign_key: true
  end
end
