module Helpers
  def auth_user(request)
    user = create(:user)

    session = create(:session, user: user)

    request.headers['Authorization'] = session.token

    [request, user, session]
  end
end
