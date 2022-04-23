class HomeController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @api_produtos = api_check(Rails.configuration.apis['products_api'])
    @api_pagamentos = api_check(Rails.configuration.apis['payments_api'])
    @api_clientes = api_check(Rails.configuration.apis['clients_api'])
    @client_qty = Client.count
    @order_qty = Order.count
    @user_qty = User.count
    @commission_qty = Commission.count
  end

  private

  def api_check(path)
    Faraday.get(path)
    true
  rescue StandardError
    false
  end
end
