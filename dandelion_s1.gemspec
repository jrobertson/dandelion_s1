Gem::Specification.new do |s|
  s.name = 'dandelion_s1'
  s.version = '0.5.0'
  s.summary = 'A kind of Rack-Rscript web server which facilitates ' +
      'static files, cookie based authentication, and private pages.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/dandelion_s1.rb']
  s.add_runtime_dependency('rack-rscript', '~> 1.4', '>=1.4.0')
  s.add_runtime_dependency('simple-config', '~> 0.7', '>=0.7.2')
  s.add_runtime_dependency('martile', '~> 1.5', '>=1.5.0')
  s.signing_key = '../privatekeys/dandelion_s1.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/dandelion_s1'
  s.required_ruby_version = '>= 3.0.2'
end
