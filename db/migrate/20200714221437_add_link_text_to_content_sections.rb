class AddLinkTextToContentSections < ActiveRecord::Migration[5.2]
  def change
    add_column :content_sections, :link_text, :string

    change_table :content_sections do |t|
      t.rename :link, :link_url
    end
  end  
end
