class AddIndexToAuthorsPackages < ActiveRecord::Migration[5.2]
  def change
    add_index :authors_packages, [ :author_id, :package_id ], unique: true
    add_index :maintainers_packages, [ :maintainer_id, :package_id ], unique: true
  end
end
