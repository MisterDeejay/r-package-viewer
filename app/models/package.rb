class Package < ApplicationRecord
  has_and_belongs_to_many :authors,
    join_table: 'authors_packages',
    class_name: 'Person',
    association_foreign_key: 'author_id'
  has_and_belongs_to_many :maintainers,
    join_table: 'maintainers_packages',
    class_name: 'Person',
    association_foreign_key: 'maintainer_id'

  def self.latest_versions
    package_name = nil
    packages = []
    Package.group("id,package_name").order("version DESC").each do |package|
      next if package_name == package.package_name
      package_name = package.package_name
      packages << package
    end

    packages
  end
end
