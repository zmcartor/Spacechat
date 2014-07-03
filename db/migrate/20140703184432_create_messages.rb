class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :space
      t.references :user
      t.string :text
      t.string :picture_url
      t.timestamps
    end
  end
end
