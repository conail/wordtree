source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'jquery-rails'
gem 'haml'
gem 'sass'
gem 'formtastic'
#gem 'fastercsv'
gem 'nokogiri', :platforms => [:ruby, :jruby] 
gem 'inherited_resources'
gem 'high_voltage'
gem 'kaminari'
gem 'neo4j'

platforms :jruby do
  gem 'activerecord-jdbc-adapter', :require => false
  gem 'jruby-openssl', :require => false
  gem 'trinidad', :require => false
end

group :development, :test do
  platforms :jruby do
    gem 'jdbc-sqlite3', :require => false
  end
  platforms :ruby do
    gem 'sqlite3-ruby', :require => 'sqlite3'
  end
end

group :production do
  platforms :jruby do
    gem 'jdbc-mysql'
  end
  platforms :ruby do
    gem 'mysql2'
  end
end

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :test do
#  gem 'turn', :require => false
end
