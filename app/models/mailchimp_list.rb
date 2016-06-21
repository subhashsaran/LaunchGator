class MailchimpList < ActiveRecord::Base
  attr_accessible :list_id, :list_name, :mailchimp_subscription_id
  belongs_to :mailchimp_subscription
end
