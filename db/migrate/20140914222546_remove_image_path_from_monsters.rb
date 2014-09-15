class RemoveImagePathFromMonsters < ActiveRecord::Migration
  def change
    remove_column :monsters, :image_path
  end
end
