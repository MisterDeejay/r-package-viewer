class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :package_name
      t.string :version
      t.datetime :published_at
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
