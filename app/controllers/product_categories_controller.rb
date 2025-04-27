class ProductCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product_category, only: [ :show, :update ]

  def index
    @product_categories = policy_scope(Product)
    render json: @product_categories
  end

  def show
    authorize @product_category
    render json: @product_category
  end

  def create
    @product_category = ProductCategory.new(product_params)
    authorize @product_category
    if @product_category.save
      render json: @product_category, status: :created
    else
      render json: @product_category.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @product_category
    if @product_category.update(product_params)
      render json: @product_category
    else
      render json: @product_category.errors, status: :unprocessable_entity
    end
  end

  private

  def set_product_category
    @product_category = ProductCategory.find(params[:id])
  end

  def product_category_params
    params.require(:product_category).permit(:name, :description)
  end
end
