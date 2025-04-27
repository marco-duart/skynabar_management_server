module StockOperations
  class AdjustIdealQuantity
    def initialize(product, user, new_quantity)
      @product = product
      @user = user
      @new_quantity = new_quantity.to_f
    end

    def call
      return error_response("Quantidade inválida") if @new_quantity < 0

      StockMovement.transaction do
        old_quantity = @product.ideal_quantity
        @product.update!(ideal_quantity: @new_quantity)

        if old_quantity != @new_quantity
          StockMovement.create!(
            product: @product,
            user: @user,
            quantity: @new_quantity,
            movement_type: :adjustment,
            notes: "Ajuste de quantidade semanal de #{old_quantity} para #{@new_quantity}"
          )
        end
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
