module StockOperations
  class Withdraw
    def initialize(product, user, quantity)
      @product = product
      @user = user
      @quantity = quantity.to_f
    end

    def call
      return error_response("Quantidade inválida") if @quantity <= 0
      return error_response("Estoque insuficiente") if @product.current_quantity < @quantity

      StockMovement.transaction do
        @product.decrement!(:current_quantity, @quantity)
        StockMovement.create!(
          product: @product,
          user: @user,
          quantity: @quantity,
          movement_type: :output,
          notes: "Retirada de #{@product.name} na quantidade #{@quantity} por #{@user.name}."
        )
      end

      success_response
    rescue ActiveRecord::RecordInvalid => e
      error_response(e.message)
    end

    private

    def success_response
      { success: true, product: @product }
    end

    def error_response(message)
      { success: false, error: message }
    end
  end
end
