class SellersController < ApplicationController
  before_action :authenticate_admin, only: %i[new create index commissions]
  before_action :authenticate_user!, only: %i[new create show index]

  def index
    @sellers = User.where(role: 'salesperson', status: :active)
    @inactive_sellers = User.where(role: 'salesperson', status: :inactive)
  end

  def show
    @seller = User.find(params[:id])
  end

  def new
    @seller = User.new
  end

  def create
    user_params = params.permit(:name, :email, :password, :password_confirmation, :status)
    @seller = User.new(user_params)

    if @seller.save
      redirect_to seller_path(@seller.id), notice: 'Vendedor cadastrado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível registrar o vendedor'
      render 'new'
    end
  end

  def commissions
    @seller = User.find(params[:id])
    @commissions = Commission.where(user_id: @seller.id)
  end

  def change_status
    seller = User.find(params[:id])
    if seller.active?
      seller.inactive!
    else
      seller.active!
    end
    redirect_to seller_path(seller.id)
  end
end
