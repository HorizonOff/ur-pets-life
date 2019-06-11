module AdminPanel
  class InvitationDecorator < ApplicationDecorator
    decorates :my_second_house_member_invitation
    delegate_all

    def created_at
      model.created_at.strftime('%-d %b %Y %I:%M %p')
    end
  end
end
