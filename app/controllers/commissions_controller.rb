class CommissionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  def index
    @commissions = if current_user.admin?
                     Commission.all
                   else
                     current_user.commissions
                   end
    @sellers = User.where(role: :salesperson)
  end
end
