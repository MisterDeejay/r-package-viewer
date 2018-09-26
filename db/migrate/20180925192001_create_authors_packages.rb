class CreateAuthorsPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :authors_packages do |t|
      t.bigint :author_id, index: true
      t.bigint :package_id, index: true
    end
  end
end
