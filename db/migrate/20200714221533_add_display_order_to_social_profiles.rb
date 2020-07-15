class AddDisplayOrderToSocialProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :social_profiles, :display_order, :integer
  end
end
