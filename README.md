# Space Manager API

## Table of contents:

* [Description](./README.md#description)
  * [Task](./README.md#task)
* [Setup](./README.md#setup)
* [Running the app](./README.md#running-the-app)
* [Running the tests](./README.md#running-the-tests)
* [Development Notes](./README.md#development-notes)

## Description

### Challenge: Help the R-Project

The way R users are looking for new packages could and should be dramatically impro- ved. Right now they use command line tools like apt / rpm and the package installer of R-Studio to do that job, but there is not a good web interface for package searching. You will help them. The goal of this challenge is to build an interface to help the R community. Why?

### What is R?

R is a language and environment for statistical computing and graphics. It is a GNU project which is similar to the S language and environment which was developed at Bell Laboratories (formerly AT&T, now Lucent Technologies). It’s a cool language, have a look to it if you don’t know it yet.

### What is CRAN?

CRAN is a network of ftp and web servers around the world that store identical, up-to- date, versions of code and documentation for R. The use these CRAN Servers to store the R packages.
A CRAN server looks like: http://cran.r-project.org/src/contrib/. It is just a simple Apache Dir with a bunch of tar.gz files.

This app is a crude version of a viewer meant to allows users to index and browse the available packages for the R language on a CRAN server. The endpoint at /packages allows clients to views packages with the following attributes. It includes a rake task that's run every 12 hours via `schedule.rb` that indexes any new versions/packages that have been added to the server.

    Packages
    # package_name - String
    # version - String
    # published - DateTime
    # Title - String
    # Description - String

## Task

We want that you create a Ruby application to index all the packages in a CRAN server. For that we want that you do:
1. Extract some information regarding every package and store it (You will need to get some info from PACKAGES file and some other info from DESCRIPTION)
2. Design the business logic needed for storing all the information (models, libs, DB structure...)
3. A task that will run every day at 12pm to index any new package that appeared during the day (we want to store all the versions of a given package. It means that the package abc 1.2.1.tar.gz could be tomorrow abc 1.3.0.tar.gz, and we want to store version 1.2.1 and 1.3.0)
4. A simple view listing all the packages you have indexed
5. Tests, of course
6. Push the code to github and send us the URL.

## Setup

1. Make sure you have Ruby 2.3 installed in your machine. If you need help installing Ruby, take a look at the [official installation guide](https://www.ruby-lang.org/en/documentation/installation/).

2. Install the [bundler gem](http://bundler.io/) by running:

    ```gem install bundler```

3. Clone this repo:

    ```git clone git@github.com:MisterDeejay/r-package-viewer.git```

4. Change to the app directory:

    ```cd r-package-viewer```

5. Install dependencies:

    ```bundle install```

## Running the app

6. Start the server

    ```rails s```

7. Create the database

    ```rails db:create db:migrate```

11. Run cron job for initial db seeding

    ```rails cron:index_packages[n]  # n is the number of packages that will be indexed```

11. Run command to tell Whenever to start running the cron job in the future

    ```whenever --update-crontab```

12. Verify command by listing all scheduled jobs

    ```crontab -l```

## Running the tests

    rspec spec/

## Development Notes
Three hours really flew by! Lots of touching up needs to be done. Given more time I would first focus with testing around the rake task and refactoring that code into reusable classes. In addition, the algorithms that parse the authors and maintainers string make assumptions about the string that may not be true. In my analysis, I was able to find a few packages whose authors strings broke the algorithm.

The query used to get the latest version of every Package was one of the last tasks completed and as such, is suboptimal. Before finalizing this task, I would focus on writing a query that does not need to iterate over the results to return the correct packages. Finally, the index view is clearly a WIP put together to allows for feedback in the browser. Ideally, the use of a frontend library using Flex, like Foundation, could be employed to really give the index view a new, updated look.
