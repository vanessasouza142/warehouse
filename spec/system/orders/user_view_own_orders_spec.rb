require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    #Arrange

    #Act
    visit root_path
    click_on 'Meus Pedidos'

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
    #Arrange
    joana = User.create!(name: 'Joana Lima', email: 'joana@example.com', password: 'password')
    carla = User.create!(name: 'Carla Golçalves', email: 'carla@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    first_order = Order.create!(warehouse: warehouse, supplier: supplier, user: joana, estimated_delivery_date: 10.days.from_now)
    second_order = Order.create!(warehouse: warehouse, supplier: supplier, user: carla, estimated_delivery_date: 10.days.from_now)
    third_order = Order.create!(warehouse: warehouse, supplier: supplier, user: joana, estimated_delivery_date: 1.week.from_now)

    #Act
    login_as(joana)
    visit root_path
    click_on 'Meus Pedidos'

    #Assert
    expect(page).to have_content first_order.code
    expect(page).to have_content third_order.code
    expect(page).not_to have_content second_order.code
  end

  it 'e vê detalhes do seu pedido' do
    #Arrange
    joana = User.create!(name: 'Joana Lima', email: 'joana@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    first_order = Order.create!(warehouse: warehouse, supplier: supplier, user: joana, estimated_delivery_date: 10.days.from_now)

    #Act
    login_as(joana)
    visit root_path
    click_on 'Meus Pedidos'
    click_on first_order.code

    #Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Galpão Destino: RIO - Aeroporto RJ'
    expect(page).to have_content 'Fornecedor: LG eletronicos Ltda'
    formatted_date = I18n.l(10.days.from_now.to_date)
    expect(page).to have_content "Data Prevista de Entrega: #{formatted_date}"
  end

  it 'e não vê detalhes de pedidos de outros usuários' do
    #Arrange
    joana = User.create!(name: 'Joana Lima', email: 'joana@example.com', password: 'password')
    andre = User.create!(name: 'André Vasconcelos', email: 'andre@example.com', password: 'password')

    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')

    first_order = Order.create!(warehouse: warehouse, supplier: supplier, user: joana, estimated_delivery_date: 10.days.from_now)
    second_order = Order.create!(warehouse: warehouse, supplier: supplier, user: andre, estimated_delivery_date: 5.days.from_now)

    #Act
    login_as(andre)
    visit order_path(first_order.id)

    #Assert
    expect(current_path).not_to eq order_path(first_order.id)
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação!'
  end
end