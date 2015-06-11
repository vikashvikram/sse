class Message < ActiveRecord::Base
  scope :last_updated, ->(interval) {
    where('created_at > ?', interval.seconds.ago).order('updated_at DESC, created_at DESC').limit(1)
  }

  scope :since_last_updated, ->(last_id) {
  	where('id > ?', last_id).order('created_at ASC')
  }
end
