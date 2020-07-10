class CreateContentSections < ActiveRecord::Migration[5.2]
  def change
    create_table :content_sections do |t|
      t.string :name
      t.string :css_class
      t.integer :page_location
      t.string :headline
      t.text :body_copy
      t.string :link
      t.timestamps
    end
  end
end
