class PackagesController < ApplicationController
  def index
    @packages = Package.latest_versions
  end
end
