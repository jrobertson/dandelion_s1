# Introducing the Dandelion_s1 gem

Dandelion_s1 is built upon Rack-Rscript and facilitates static files, basic authentication, and private pages.

## Example

    # file: ds1.ru

    require 'dandelion_s1'

    use Rack::Auth::Basic, "Restricted Area" do |user, password|

      passwords = {"user" => "0rang3", "rubycafe" => "c4g31"}
      passwords[user] == password
      
    end

    options = {
      pkg_src: 'http://rorbuilder.info/r', 
       static: %w(dynarex css images), 
       access: {'/do/r/hello' => 'user'},
         root: 'www'
    }

    run DandelionS1.new(options)

## Running the example      

`rackup ds1.ru -p 3003`

Then point your browser to `http://127.0.0.1:3003/do/r/hello` and it should request a username and password. Enter the username *user* and password *0rang3*. The date and time should then be observed on the web page.

## Options

* **pkg_src** This is the URL to the web server which has the RSF package files
* **static** (optional) Directories or files in the root directory which are to be accessible from this web server
* **access** (optional) Private pages only a specific user can access
* **root**   (optional) The web server root directory for serving static files.

Note: The middleware Rack::Static could have been used, however I wanted something more flexible i.e. default index.html file rendered when a directory name is given.

## Resources

* [jrobertson/dandelion_s1](https://github.com/jrobertson/dandelion_s1)

dandelion_s1 gem
