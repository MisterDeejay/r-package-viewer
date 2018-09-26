class Person < ApplicationRecord
  has_and_belongs_to_many :authored_packages,
    join_table: 'authors_packages',
    class_name: 'Package',
    foreign_key: 'author_id'
  has_and_belongs_to_many :maintained_packages,
    join_table: 'maintainers_packages',
    class_name: 'Package',
    foreign_key: 'maintainer_id'
end
