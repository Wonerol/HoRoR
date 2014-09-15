module MonstersHelper

  # Returns the image path
  def image_path_for(monster)
    image_path = "monsters/#{monster.name.split.join('_')}_Trans.png"
  end

end
