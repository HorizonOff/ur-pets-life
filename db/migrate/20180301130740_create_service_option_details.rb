class CreateServiceOptionDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :service_option_details do |t|
      t.references :service_option, foreign_key: true
      t.references :service_optionable, polymorphic: true, index: { name: "index_service_and_option" }
      t.datetime   :deleted_at
      t.integer    :price

      t.timestamps

      t.index      :deleted_at
    end

    create_join_table :appointments, :pets
  end
end
