class AdminsController < AuthenticatesController
  before_action :require_admin

  def require_admin
    unless current_user.admin
      redirect_to root_path, error: "You are not allowed to do that."
    end
  end
end
