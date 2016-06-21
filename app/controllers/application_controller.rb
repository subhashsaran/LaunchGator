class ApplicationController < ActionController::Base
  include UrlHelper

  before_filter :fetch_site_and_set_background
  before_filter :mailer_set_url_options
  helper :all

  private

  def after_sign_in_path_for(current_user)
    if !admin_user_signed_in?
      @user = current_user
      @site = @user.site
      edit_site_path(@site)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def fetch_site_and_set_background
    if ((request.domain.to_s != "deskgator.com") and (request.domain.to_s != "localhost"))
      # subdomain = request.subdomain.to_s.gsub('.launch','')
      begin
        # @site = Site.find_by_domain_name!(subdomain)
        if Rails.env.development?
            @site  = Site.find 2
        else
            @site = Site.find_site_from_orignal_url(request.original_url)
        end
      rescue ActiveRecord::RecordNotFound
        # flash[:error] = "This record does not exist."
        # redirect_to(root_path(:subdomain => false))
        raise ActionController::RoutingError.new('Not Found')
      end
    elsif params[:controller] == "sites" && params[:action] == "edit"
      @site = Site.find(params[:id])
    else
      @site = Site.find(1)
    end

    if !@site.nil? and @site.id != 1  and !@site.image.nil? and !@site.image.background_file_name.nil?
      @background_image = @site.image.background.url
    else
      @background_image = "/assets/bg.jpg"
    end

    if @site.nil? or @site.id == 1
      @title = "LaunchGator - Create a viral launching soon page in minutes"
    else
      @title  =  @site.name
    end

  end

  def site_visited_or_not(site_id)
    return Invite.find(:first, :conditions =>["cookie = ? and site_id = ?", cookies[:invite],site_id])
  end

  def super_admin_acces
    if current_user.nil? or current_user.account_type !='super_admin'
      redirect_to root_path
    end
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

end
