class LandingController < ApplicationController
   def index
    render text: index_html
  end

  private

  def index_html
    redis.get "#{deploy_key}:index.html"
  end

  # By default serve release, if canary is specified then the latest
  # known release, otherwise the requested version.
  def deploy_key
    params[:version] ||= 'release'
    case params[:version]
    when 'release' then 'release'
    when 'canary'  then  redis.lindex('releases', 0)
    else
      params[:version]
    end
  end

  def redis
    if Rails.env.development?
      redis = Redis.new
    else
      Redis.new(:url => ENV['REDIS_HOST'])
    end
  end
end