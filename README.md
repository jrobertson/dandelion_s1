# Dandelion_s1 now uses cookie based authentication

Dandelion_s1 is built upon Rack-Rscript and facilitates static files, coookie based authentication, and private pages.

## Example

    # file: ds1.ru

    require 'dandelion_s1'

    use Rack::Static, :urls => ['/xsl', '/dynarex'], :root => 'www'
    use Rack::Session::Cookie, :key => 'rack.session',
      :expire_after => 2592000,
      :secret => 'change_me'

    h = {
      pkg_src: 'http://rorbuilder.info/r',
      log_file: '/tmp/ds1.log',
      rsc_host: 'rse',
      rsc_package_src: 'http://yoursite.com',
      debug: true
    }

    run DandelionS1.new(h)

## Running the example

`rackup ds1.ru -p 3003`

Then point your browser to `http://127.0.0.1:3003/do/r/hello` and it should request a username and password. Enter the username *user* and password *0rang3*. The date and time should then be observed on the web page.

## Options

* **pkg_src** This is the URL to the web server which has the RSF package files
* **static** (optional) Directories or files in the root directory which are to be accessible from this web server
* **access** (optional) Private pages only a specific user can access
* **root**   (optional) The web server root directory for serving static files.

Note: The rorbuilder.info domain used in this example is no longer owned by me, however I still use that domain name locally on my intranet.

## Resources

* [jrobertson/dandelion_s1](https://github.com/jrobertson/dandelion_s1)

rack dandelion_s1 dandelions1 dandelion cookies cookie session
