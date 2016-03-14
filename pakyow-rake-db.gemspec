version = File.read(File.join(File.expand_path("../VERSION", __FILE__))).strip

Gem::Specification.new do |gem|
  gem.name          = 'pakyow-rake-db'
  gem.summary       = 'Rake db tasks for Pakyow.'
  gem.description   = 'Useful rake tasks for dealing with databases in Pakyow.'
  gem.license       = 'MIT'
  gem.author        = 'Bryan Powell'
  gem.email         = 'bryan@metabahn.com'
  gem.homepage      = 'https://pakyow.org'
  gem.require_path  = 'lib'
  gem.version       = version

  gem.files         = [
                      'CHANGES',
                      'README.md',
                      'LICENSE',
                      'lib/**/*'
                    ]

  gem.add_dependency('pakyow-support', '~> 0.9')
  gem.add_dependency('pakyow-core', '~> 0.9')
  gem.add_dependency('sequel', '~> 4.25')
  gem.add_dependency('rake', '~> 11.1')
end
