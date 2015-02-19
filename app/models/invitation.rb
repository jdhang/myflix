# Schema Information
#
# Table name: invitations
#
# inviter_id               integer
# name                     string
# email                    string
# message                  text
# registered               boolean
# created_at               datetime
# updated_at               datetime
#

class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'

  validates :email, presence: true

  def register
    registered = true
  end

  def unregister
    registered = false
  end

end
