class LandingController < ApplicationController
  def index  
    redis
    index_key &&= "propelx-ember:#{index_key}"
    index_key ||= redis.get("propelx-ember:current")
    render text: redis.get(index_key)
  end

  # def index
  #   render text: index_html
  # end

  # private

  # def index_html
  #   redis.get "#{deploy_key}:index.html"
  # end

  # # By default serve release, if canary is specified then the latest
  # # known release, otherwise the requested version.
  # def deploy_key
  #   params[:version] ||= 'release'
  #   case params[:version]
  #   when 'release' then 'release'
  #   when 'canary'  then  redis.lindex('releases', 0)
  #   else
  #     params[:version]
  #   end
  # end

  def redis
    if Rails.env.development?
      redis = Redis.new
    else
      Redis.new(:url => ENV['REDISCLOUD_URL'])
    end
  end
end