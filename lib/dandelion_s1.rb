#!/usr/bin/env ruby

# file: dandelion_s1.rb

require 'rack-rscript'


class DandelionS1 < RackRscript

  def initialize(h={})

    raw_opts = {root: 'www', access: {}, static: []}.merge h
    #@static = %w(index.html dynarex snippets)
    @static = raw_opts[:static]
    @root = raw_opts[:root]

    #@access_list = {'/do/r/hello3' => 'user'}
    @access_list = raw_opts[:access]

    super(raw_opts)
  end

  def call(e)

    private_user = @access_list[e['REQUEST_PATH']]

    if private_user.nil? or private_user == e['REMOTE_USER'] then
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

      filepath = File.join(@root, path)

      if path.length < 1 or path[-1] == '/' then
        path += 'index.html' 
        File.read File.join(@root, path)
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
