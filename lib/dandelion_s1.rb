#!/usr/bin/env ruby

# file: dandelion_s1.rb

require 'rack-rscript'
require 'simple-config'


class DandelionS1 < RackRscript

  def initialize(h={})

    raw_opts = {root: 'www', access: {}, static: []}.merge h
    @app_root = Dir.pwd

    @static = raw_opts[:static]
    @root = raw_opts[:root]

    #@access_list = {'/do/r/hello3' => 'user'}
    access_list = raw_opts[:access]
        
    h2 = SimpleConfig.new(access_list).to_h
    conf_access = h2[:body] || h2
    @access_list = conf_access.inject({}) \
                                {|r,x| k,v = x; r.merge(k.to_s => v.split)}
    
    super(logfile: h[:logfile],  pkg_src: h[:pkg_src], rsc_host: h[:rsc_host], 
          rsc_package_src: h[:rsc_package_src])
  end

  def call(e)

    private_user = @access_list[e['REQUEST_PATH']]
    
    
    if private_user.nil? then 
      super(e)
    elsif private_user.is_a? String and private_user == e['REMOTE_USER']
      super(e)
    elsif private_user.is_a? Array and private_user.any? {|x| x == e['REMOTE_USER']}
      super(e)
    else
      request = '/unauthorised/'
      content, content_type, status_code = run_route(request)        
      content_type ||= 'text/html'
      [status_code=401, {"Content-Type" => content_type}, [content]]
    end

  end

  def default_routes(env, params)

    super(env, params)

    get /^(\/(?:#{@static.join('|')}).*)/ do |path|

      filepath = File.join(@app_root, @root, path)
      log("root: %s path: %s" % [@root, path])

      if path.length < 1 or path[-1] == '/' then
        path += 'index.html' 
        File.read filepath
      elsif File.directory? filepath then
        Redirect.new (path + '/') 
      elsif File.exists? filepath then
        h = {xml: 'application/xml', html: 'text/html', png: 'image/png', 
             jpg: 'image/jpeg', txt: 'text/plain', css: 'text/css',
             xsl: 'application/xml'}
        content_type = h[filepath[/\w+$/].to_sym]
        [File.read(filepath), content_type || 'text/plain']
      else
        'oops, file ' + filepath + ' not found'
      end

    end

    get /^\/$/ do

      file = File.join(@root, 'index.html')
      File.read file
    end

    get '/unauthorised/' do
      'unauthorised user'
    end
 
  end 

end
