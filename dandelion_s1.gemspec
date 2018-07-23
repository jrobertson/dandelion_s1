Gem::Specification.new do |s|
  s.name = 'dandelion_s1'
  s.version = '0.3.0'
  s.summary = 'A kind of Rack-Rscript web server which facilitates ' +
      'static files, cookie based authentication, and private pages.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/dandelion_s1.rb']
  s.add_runtime_dependency('rack-rscript', '~> 1.1', '>=1.1.2')
  s.add_runtime_dependency('simple-config', '~> 0.6', '>=0.6.4')
  s.add_runtime_dependency('martile', '~> 0.9', '>=0.9.1')
  s.signing_key = '../privatekeys/dandelion_s1.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/dandelion_s1'
  s.required_ruby_version = '>= 2.1.2'
end
