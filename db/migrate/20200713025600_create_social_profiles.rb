class CreateSocialProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :social_profiles do |t|
      t.string :name
      t.string :handle
      t.integer :social_platform_id
    end
  end
end
