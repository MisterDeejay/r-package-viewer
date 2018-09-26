class CreateMaintainersPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :maintainers_packages do |t|
      t.bigint :maintainer_id, index: true
      t.bigint :package_id, index: true
    end
  end
end
