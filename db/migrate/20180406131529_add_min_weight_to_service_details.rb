class AddMinWeightToServiceDetails < ActiveRecord::Migration[5.1]
  def up
    add_column :service_details, :min_weight, :float, default: 0

    ServiceDetail.where(weight: nil).each do |sd|
      sd.update_attribute(:weight, 100)
    end
  end

  def down
    remove_column :service_details, :min_weight, :float
    GroomingCentre.all.each do |gc|
      gc.service_details.each do |sd|
        sd.update_attibute(:weight, nil)
      end
    end
  end
end
