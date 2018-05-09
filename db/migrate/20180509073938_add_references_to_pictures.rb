class AddReferencesToPictures < ActiveRecord::Migration[5.1]
  def up
    add_reference    :pictures,     :picturable,    polymorphic: true

    Picture.all.each do |c|
      c.picturable_type = 'Pet'
      c.picturable_id = c.pet_id
      c.save
    end

    remove_reference :pictures, :pet
  end

  def down
    add_reference    :pictures, :pet, foreign_key: true

    Picture.where(picturable_type: 'Pet').each do |c|
      c.pet_id = c.picturable_id
      c.save
    end

    remove_reference    :comments, :picturable, polymorphic: true
  end
end
