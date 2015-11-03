Gem::Specification.new do |s|
  s.name = 'dandelion_s1'
  s.version = '0.1.5'
  s.summary = 'A kind of Rack-Rscript web server which facilitates static files, basic authentication, and private pages.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('rack-rscript', '~> 0.6', '>=0.6.0')
  s.signing_key = '../privatekeys/dandelion_s1.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dandelion_s1'
  s.required_ruby_version = '>= 2.1.2'
end
