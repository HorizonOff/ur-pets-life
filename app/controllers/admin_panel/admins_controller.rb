module AdminPanel
  class AdminsController < AdminPanelController
    def index
      @admins = Admin.all
    end
  end
end
