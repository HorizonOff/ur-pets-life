class AddReferenceToDiagnosis < ActiveRecord::Migration[5.1]
  def change
    add_reference :diagnoses, :pet, foreign_key: true
  end
end
