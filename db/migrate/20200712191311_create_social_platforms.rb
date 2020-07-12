class CreateSocialPlatforms < ActiveRecord::Migration[5.2]
  def change
    create_table :social_platforms do |t|
      t.string :name
      t.string :base_url
      t.string :image_file_name
    end
  end
end
