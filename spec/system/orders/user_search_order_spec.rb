require 'rails_helper'

describe 'Usuário faz a busca de um pedido' do
  it 'a partir do menu' do
    #Arrange
    user = User.create!(name: 'Joana Lima', email: 'joana@example.com', password: 'password')

    #Act
    login_as(user)
    visit root_path

    #Assert
    within('header nav') do
      expect(page).to have_field 'Buscar Pedido'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'e não está autenticado' do
    #Arrange

    #Act
    visit root_path

    #Assert
    within('header nav') do
      expect(page).not_to have_field 'Buscar Pedido'
      expect(page).not_to have_button 'Buscar'
    end
  end

  it 'e encontra um pedido' do
    #Arrange
    user = User.create!(name: 'Joana Lima', email: 'joana@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                      address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    order = Order.create!(warehouse: warehouse, supplier: supplier, user: user, estimated_delivery_date: 10.days.from_now)

    #Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: order.code
    click_on 'Buscar'

    #Assert
    expect(page).to have_content "Resultados da Busca por: #{order.code}"
    expect(page).to have_content '1 pedido encontrado'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'Galpão Destino: RIO - Aeroporto RJ'
    expect(page).to have_content 'Fornecedor: LG eletronicos Ltda'
  end

  it 'e encontra múltiplos pedidos' do
    #Arrange
    user = User.create!(name: 'Joana Lima', email: 'joana@example.com', password: 'password')
    first_warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    second_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                        address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('RIO12345')
    first_order = Order.create!(warehouse: first_warehouse, supplier: supplier, user: user, estimated_delivery_date: 10.days.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('RIO89748')
    second_order = Order.create!(warehouse: first_warehouse, supplier: supplier, user: user, estimated_delivery_date: 10.days.from_now)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('GRU00000')
    third_order = Order.create!(warehouse: second_warehouse, supplier: supplier, user: user, estimated_delivery_date: 10.days.from_now)

    #Act
    login_as(user)
    visit root_path
    fill_in 'Buscar Pedido', with: 'RIO'
    click_on 'Buscar'

    #Assert
    expect(page).to have_content '2 pedidos encontrados'
    expect(page).to have_content 'Código: RIO12345'
    expect(page).to have_content 'Código: RIO89748'
    expect(page).to have_content 'Galpão Destino: RIO - Aeroporto RJ'
    expect(page).not_to have_content 'Código: GRU00000'
    expect(page).not_to have_content 'Galpão Destino: GRU - Aeroporto SP'
  end
end