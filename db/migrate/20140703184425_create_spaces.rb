class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string :banner_url
      t.string :name
      t.string :invite_code
      t.timestamps
    end
  end
end
