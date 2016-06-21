class MailchimpSubscription < ActiveRecord::Base
  attr_accessible :api_key, :user_id
  has_many :mailchimp_lists
  belongs_to :user
end
