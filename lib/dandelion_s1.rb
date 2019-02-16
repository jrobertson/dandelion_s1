#!/usr/bin/env ruby

# file: dandelion_s1.rb

require 'martile'
require 'rack-rscript'
require 'simple-config'


class DandelionS1 < RackRscript

  def initialize(opts={})

    h = {root: 'www', static: [], passwords: {'user' => 'us3r'}}.merge(opts)
    
    @passwords = h[:passwords]
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
    @log.debug '@access_list: ' + @access_list.inspect if @log    
    @log.debug 'end of initialize' if @log
    
  end

  def call(e)

    request = e['REQUEST_PATH']
    @log.debug 'request: ' + request.inspect if @log
    
    return super(e) if request == '/login'
    r = @access_list.detect {|k,v| request =~ Regexp.new(k)} if @access_list
    private_user = r ? r.last : nil
    
    req = Rack::Request.new(e)
    user = req.session[:username]

    #@log.debug 'user: ' + user.inspect if @log
    #@log.debug '@e: ' + e.inspect if @log
    return jumpto '/login2?referer=' + e['PATH_INFO'] unless user
    
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
    
    log = @log
    
    get '/login2/*' do
      params[:splat].inspect
      redirect '/login' + params[:splat].first
    end
    
    get '/login/*' do      
      url = params[:splat].any? ? params[:splat][0][/(?<=referer=).*/] : '/'
      login_form(referer: url)      
    end    
    
    post '/login' do
      
      h = @req.params

      if @passwords[h['username']] == h['password'] then
        
        @req.session[:username] = h['username']
        #'you are now logged in as ' + h['username']
        redirect h['referer']
        
      else
        
        login_form('Invalid username or password, try again.',401)
        
      end

      
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
      ['unauthorised user', 'text/plain', 403]      
    end
    
    super(env, params)   
 
  end   
  
  def login_form(msg='Log in to this site.', http_code=200, referer: '/')
    
s=<<EOF      
p #{msg}

login
  username: [     ]
  password: [     ]
  [! referer: #{referer}
   ]
  [login](/login)
EOF

    [Martile.new(s).to_s, 'text/slim', http_code]

  end


end
