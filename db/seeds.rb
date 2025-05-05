require 'faker'

Faker::Config.locale = 'pt-BR'

puts "Criando usuários..."
User.create!(
  document: CPF.generate,
  email: Faker::Internet.unique.email,
  password: "password",
  password_confirmation: "password",
  name: Faker::Name.name,
  role: 1,
  confirmed_at: Time.now
)

3.times do
  User.create!(
    document: CPF.generate,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password",
    name: Faker::Name.name,
    role: 0,
    confirmed_at: Time.now
  )
end

puts "Criando categorias..."
categories = [
  { name: "Bebidas Alcoólicas", description: "Vinhos, cervejas e destilados" },
  { name: "Bebidas Não Alcoólicas", description: "Refrigerantes, sucos e água" },
  { name: "Ingredientes", description: "Frutas, especiarias e outros ingredientes" },
  { name: "Material de Limpeza", description: "Produtos para limpeza do bar" }
].map { |cat| ProductCategory.create!(cat) }

puts "Criando produtos..."
50.times do
  Product.create!(
    name: Faker::Commerce.unique.product_name,
    sku: "#{Faker::Alphanumeric.unique.alphanumeric(number: 8).upcase}",
    unit_type: Product.unit_types.keys.sample,
    current_quantity: Faker::Number.between(from: 5.0, to: 20.0).round(1),
    ideal_quantity: Faker::Number.between(from: 10.0, to: 30.0).round(1),
    product_category: categories.sample
  )
end

puts "Criando histórico de movimentações..."
users = User.all
products = Product.all

200.times do
  product = Product.lock.find(products.sample.id)
  movement_type = [ :input, :output ].sample

  max_quantity = if movement_type == :output
                   [ product.current_quantity, 5.0 ].min
  else
                   Faker::Number.between(from: 1.0, to: 10.0).round(2)
  end

  quantity = Faker::Number.between(from: 0.1, to: max_quantity).round(2)

  ActiveRecord::Base.transaction do
    StockMovement.create!(
      product: product,
      user: users.sample,
      quantity: quantity,
      movement_type: movement_type,
      notes: Faker::Lorem.paragraph,
      created_at: Faker::Time.between(from: 3.months.ago, to: Time.now)
    )

    new_quantity = movement_type == :input ?
                  (product.current_quantity + quantity).round(2) :
                  (product.current_quantity - quantity).round(2)

    if new_quantity.negative?
      raise ActiveRecord::Rollback, "Estoque não pode ficar negativo"
    end

    product.update!(current_quantity: new_quantity)
  end
end

puts "Seed concluído com sucesso!"
puts "#{User.count} usuários criados"
puts "#{ProductCategory.count} categorias criadas"
puts "#{Product.count} produtos criados"
puts "#{StockMovement.count} movimentações criadas"
