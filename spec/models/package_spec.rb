require 'rails_helper'

RSpec.describe Package, type: :model do
  it { should have_and_belong_to_many(:authors) }
  it { should have_and_belong_to_many(:maintainers) }

  describe ".latest_versions scope" do
    let!(:package) { FactoryBot.create(:package, package_name: 'Package', version: 'v2.0')}
    let!(:old_package) { FactoryBot.create(:package, package_name: 'Package', version: 'v1.0')}

    it "return the latest version of every package" do
      expect(Package.latest_versions.length).to eq(1)
      expect(Package.latest_versions.first.package_name).to eq('Package')
      expect(Package.latest_versions.first.version).to eq('v2.0')
    end
  end
end
