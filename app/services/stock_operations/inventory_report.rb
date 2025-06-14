module StockOperations
  class InventoryReport
    def initialize(user)
      @user = user
    end

    def call
      {
        stock_movements: stock_movements_data,
        indicators: {
          most_moved_products: most_moved_products,
          low_stock_products: low_stock_products,
          movement_stats: movement_stats,
          recent_activity: recent_activity
        }
      }
    end

    private

    def stock_movements_data
      StockMovement.includes(:product, :user)
                   .order(created_at: :desc)
                   .limit(100)
                   .map do |movement|
        {
          id: movement.id,
          quantity: movement.quantity,
          movement_type: movement.movement_type,
          notes: movement.notes,
          created_at: movement.created_at,
          product: {
            id: movement.product.id,
            name: movement.product.name,
            sku: movement.product.sku,
            current_quantity: movement.product.current_quantity,
            ideal_quantity: movement.product.ideal_quantity,
            restock_percentage: movement.product.restock_percentage,
            unit_type: movement.product.unit_type,
            category: movement.product.product_category&.name
          },
          user: {
            id: movement.user.id,
            name: movement.user.name,
            role: movement.user.role,
            email: movement.user.email
          }
        }
      end
    end

    def most_moved_products
      Product.joins(:stock_movements)
             .select("products.*, SUM(ABS(stock_movements.quantity)) as total_movement")
             .group("products.id")
             .order("total_movement DESC")
             .limit(5)
             .map do |product|
        {
          id: product.id,
          name: product.name,
          sku: product.sku,
          total_movement: product.total_movement,
          unit_type: product.unit_type
        }
      end
    end

    def low_stock_products
      Product.all
             .select { |p| p.current_quantity < p.ideal_quantity }
             .sort_by { |p| p.current_quantity / p.ideal_quantity }
             .take(5)
             .map do |product|
        {
          id: product.id,
          name: product.name,
          current_quantity: product.current_quantity,
          ideal_quantity: product.ideal_quantity,
          restock_percentage: product.restock_percentage,
          quantity_to_buy: product.quantity_to_buy,
          unit_type: product.unit_type
        }
      end
    end

    def movement_stats
      {
        inputs: StockMovement.input.sum(:quantity),
        outputs: StockMovement.output.sum(:quantity),
        adjustments: StockMovement.adjustment.count,
        total_movements: StockMovement.count
      }
    end

    def recent_activity
      StockMovement.where(created_at: 1.week.ago..Time.now)
               .group("DATE(created_at)")
               .count
               .transform_keys { |date| date.to_date.strftime("%d/%m") }
    end
  end
end
