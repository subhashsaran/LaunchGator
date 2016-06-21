module ApplicationHelper
	def active_class(action,action_match)
	  if action == action_match
	    'signupbtn'
	  else
	    nil
	  end
	end

  def from_session_if_present(user)
    checked_email = session[:checked_email]
    session[:checked_email] = nil
    checked_email and user.email.blank? ? checked_email : user.email
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end

  def active_or_inactive_domain(site_url)
    if site_url.persisted?
      site_url.active ? "active" : "inactive"
    end
  end

  def mailchimp_text_url
    current_user.mailchimp_subscriptions.size > 0 ? ["Mailchimp settings",mailchimp_subscribe_path] : ["Connect Mailchimp","http://launch.deskgator.com/auth/mailchimp"]
  end

  def fetch_list_for_user
   subscription =  current_user.mailchimp_subscriptions.last
   list = subscription.mailchimp_lists
   return list,subscription.api_key
  end 
  
end
