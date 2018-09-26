require 'rails_helper'

RSpec.describe Person, type: :model do
  it { should have_and_belong_to_many(:authored_packages) }
  it { should have_and_belong_to_many(:maintained_packages) }
end
