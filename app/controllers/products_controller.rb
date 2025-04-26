class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [ :show, :update, :update_ideal_quantity ]

  def index
    authorize Product
    @products = policy_scope(Product)
    render json: @products
  end

  def show
    authorize @product
    render json: @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @product
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def shopping_list
    authorize Product
    @products = policy_scope(Product)
               .select(&:needs_restock?)
               .sort_by(&:restock_percentage)

    render json: @products.map { |p|
      {
        id: p.id,
        name: p.name,
        current: p.current_quantity,
        ideal: p.ideal_quantity,
        to_buy: p.quantity_to_buy,
        unit_type: p.unit_type
      }
    }
  end

  def update_ideal_quantity
    authorize @product
    if @product.update(ideal_quantity: params[:ideal_quantity])
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :current_quantity, :ideal_quantity, :unit_type, :product_category_id)
  end
end
