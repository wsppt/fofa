# encoding: utf-8
require "resque"
require "#{Rails.root}/app/jobs/url_worker.rb"

class UserhostController < ApplicationController
  def index
    
  end
  
  def addhost
    @info = "感谢您的提交，我们会尽快更新（一般5分钟内会自动更新，最长第二天能完成）！"
    @host = params['host']
    #render :text => @host
    url = Domainatrix.parse(@host)
    if url.domain.size>0 && url.public_suffix
      @userhost = Userhost.create("host"=>@host, "clientip"=>request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip )
      Resque.enqueue(Processor, @host)
      @host = url
    else
      @info = "HOST格式错误"
    end
    #@info = url.inspect
    #render :inline => @info
    render :action => "index"
    #render "index" 
  end
end
