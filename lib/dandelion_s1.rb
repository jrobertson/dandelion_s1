#!/usr/bin/env ruby

# file: dandelion_s1.rb

require 'martile'
require 'rack-rscript'
require 'simple-config'


class DandelionS1 < RackRscript

  def initialize(opts={})

    h = {root: 'www', static: []}.merge(opts)
    
    access_list = h[:access]
    @app_root = Dir.pwd

    #@access_list = {'/do/r/hello3' => 'user'}
        
    if access_list then
      
      h2 = SimpleConfig.new(access_list).to_h
      conf_access = h2[:body] || h2
      @access_list = conf_access.inject({}) \
                                  {|r,x| k,v = x; r.merge(k.to_s => v.split)}
    
    end
    
    h3 = %i(log pkg_src rsc_host rsc_package_src root static debug)\
        .inject({}) {|r,x| r.merge(x => h[x])}
    
    super(h3)
    
  end

  def call(e)

    request = e['REQUEST_PATH']
    
    return super(e) if request == '/login'
    r = @access_list.detect {|k,v| request =~ Regexp.new(k)} if @access_list
    private_user = r ? r.last : nil
    
    req = Rack::Request.new(e)
    user = req.session[:username]
    #return [status_code=401, {"Content-Type" => 'text/plain'}, [user.inspect]]
    return jumpto '/login' unless user
    
    if private_user.nil? then
      super(e)
    elsif (private_user.is_a? String and private_user == user) \
        or (private_user.is_a? Array and private_user.any? {|x| x == user})
      super(e)
    else
      jumpto '/unauthorised'
    end

  end
  
  protected
  
  def default_routes(env, params) 
    
    get '/login' do
      
s=<<EOF      
login
  username: [     ]
  password: [     ]

  [login]('/login')
EOF

      Martile.new(s).to_html
    end    
    
    post '/login' do
      
      h = @req.params
      @req.session[:username] = h['username']

      'you are now logged in as ' + h['username']
      
    end
        
    get '/logout' do
      
      @req.session.clear
      'you are now logged out'
      
    end       
    
    get '/session' do
      
      #@req.session.expires
      #@req.session.options[:expire_after] = 1
      @req.session.options.inspect
      
    end
    
    get '/user' do
      
      if @req.session[:username] then
        'You are ' + @req.session[:username]
      else
        'you need to log in to view this page'
      end      
      
    end

    get '/unauthorised' do
      'unauthorised user'
    end
    
    super(env, params)   
 
  end   
  
  private
  
  def jumpto(request)
    
    content, content_type, status_code = run_route(request)        
    content_type ||= 'text/html'
    [status_code=401, {"Content-Type" => content_type}, [content]]    
    
  end

end
