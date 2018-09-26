# Learn more: http://github.com/javan/whenever
ENV['RAILS_ENV'] = 'development'

set :output, 'log/whenever.log'
every 12.hours do
  rake 'cron:index_packages'
end
