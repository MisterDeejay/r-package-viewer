require 'open-uri'
require 'zlib'
require 'rubygems/package'
require 'dcf'
namespace :cron do
  desc "Index new R packages from CRAN servers"
  task :index_packages, [:package_number] => :environment do |t, args|
    cran_server_url = 'https://cran.r-project.org/src/contrib/'
    doc = Nokogiri::HTML(open(cran_server_url))
    package_filenames = get_package_filenames(doc.css('a'), args[:package_number].to_i)
    packages_list_url = cran_server_url + 'PACKAGES'
    file = open(packages_list_url)
    packages_params = Dcf.parse(file.read)
    create_or_update_packages(packages_params, args[:package_number].to_i)

    package_filenames.each do |package_filename|
      bar = ProgressBar.create(
        title: "Indexing new R package from CRAN server",
        total: package_filenames.count
      )

      package_url = cran_server_url + package_filename
      package_name = package_filename.split('_').first
      tar_extract = Gem::Package::TarReader.new(
        Zlib::GzipReader.new(open(package_url))
      )
      tar_extract.rewind
      tar_extract.each do |entry|
        if entry.full_name == package_name + '/DESCRIPTION'
          package_details = Dcf.parse(entry.read).first
          package = create_or_update_package(package_details)
          authors = create_or_update_authors(package_details['Author'], package)
          maintainers = create_or_update_maintainers(package_details['Maintainer'], package)
        end
      end

      bar.increment
    end
  end

  def create_or_update_package(package_details)
    p = Package.find_or_create_by!(
      package_name: package_details['Package'],
      version: package_details['Version']
    )
    p.update_attributes(
      published_at: package_details['Date'],
      title: package_details['Title'],
      description: package_details['Description']
    )
    p
  end

  def reformat_date(date)
    new_date = [ nil ]
    dates_arr = date.split('-')
    dates_arr.each do |part|
      if part.length == 4
        new_date[0] = part
      else
        new_date << part
      end
    end

    swap(new_date, 1, 2)
  end

  def swap(arr, i, i2)
    temp = arr[i]
    arr[i] = arr[i2]
    arr[i2] = temp
    arr
  end

  def create_or_update_packages(packages_params, n=50)
    packages = []
    i = 0
    until packages.count == n
      bar = ProgressBar.create(
        title: "Initializing packages with info from /PACKAGES",
        total: n
      )
      p = Package.find_or_create_by!(
        package_name: packages_params[i]['Package'],
        version: packages_params[i]['Version']
      )
      if p.present?
        packages << p
        bar.increment
      end

      i += 1
    end

    packages
  end

  def create_or_update_authors(authors_string, package)
    authors = []
    authors_names = parse_authors_string(authors_string)
    authors_names.each do |name|
      begin
        author = Person.find_or_create_by!(
          name: name
        )
        author.authored_packages << package unless author.authored_packages.include?(package)
        author.save!
        authors << author
      rescue => e
        puts e.message
      end
    end

    authors
  end

  # Assumes authors_string is in the format:
  # fname lname, fname lname and fname lname
  def parse_authors_string(authors_string)
    authors = []
    name_so_far = ''
    inside_brackets = false
    (0...authors_string.length).each do |i|
      if authors_string[i] == '[' || authors_string[i] == ']' || authors_string[i] == ',' || name_so_far[-3..-1] == 'and'
        inside_brackets = true if authors_string[i] == '['
        inside_brackets = false if authors_string[i] == ']'
        if authors_string[i] == ',' || name_so_far[-3..-1] == 'and'
          if name_so_far[-3..-1] == 'and'
            authors << name_so_far[0..-4].strip
          else
            authors << name_so_far.strip
          end
          name_so_far = ''
        end
      else
        name_so_far << authors_string[i] unless inside_brackets
      end
    end

    authors << name_so_far.strip
  end

  def create_or_update_maintainers(maintainer_string, package)
    maintainer_params = parse_maintainer_string(maintainer_string)
    maintainer = Person.find_or_create_by!(
      name: maintainer_params[:name]
    )
    maintainer.email = maintainer_params[:email] if maintainer_params[:email]
    maintainer.maintained_packages << package unless maintainer.maintained_packages.include?(package)
    maintainer.save!
  rescue => e
    puts e.message
  end

  # Assumes maintainer_string is in the format:
  # fname lname <email@domain.com>
  def parse_maintainer_string(str)
    maintainer = { name: nil, email: nil }
    inside_email = true
    name_so_far = ''
    (0...str.length).each do |i|
      if str[i] == '<'
        maintainer[:name] = name_so_far.strip
        inside_email = true
        name_so_far = ''
      elsif str[i] == '>'
        maintainer[:email] = name_so_far.strip
      else
        name_so_far << str[i]
      end
    end

    maintainer
  end

  def get_package_filenames(links, n=50)
    package_filenames = []
    i = 0
    until package_filenames.count == n
      bar = ProgressBar.create(
        title: "Retrieving package links...",
        total: n
      )
      if links[i]['href'] =~ /.tar.gz\z/
        package_filenames << links[i]['href']
        bar.increment
      end

      i += 1
    end

    package_filenames
  end
end
