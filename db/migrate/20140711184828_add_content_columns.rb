class AddContentColumns < ActiveRecord::Migration
  def change
    add_column :messages, :content_id, :integer
    add_column :messages, :content_image_url, :string
    add_column :messages, :content_name, :string
    add_column :messages, :content_author, :string

  end
end
