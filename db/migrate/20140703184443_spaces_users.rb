class SpacesUsers < ActiveRecord::Migration
  def change
    create_table :spaces_users do |t|
      t.references :user
      t.references :space
      t.timestamps
    end
  end
end
