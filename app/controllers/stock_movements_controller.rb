class StockMovementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stock_movement, only: [ :show ]

  def index
    authorize StockMovement
    @stock_movements = policy_scope(StockMovement).includes(:product, :user)
    render json: @stock_movements
  end

  def show
    authorize @stock_movement
    render json: @stock_movement
  end

  def inventory_report
    authorize StockMovement
    report = StockOperations::InventoryReport.new(current_user).call
    render json: report
  end

  private

  def set_stock_movement
    @stock_movement = StockMovement.find(params[:id])
  end
end
