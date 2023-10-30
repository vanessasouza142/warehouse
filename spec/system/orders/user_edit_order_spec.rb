require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e deve estar autenticado' do
    #Arrange
    andre = User.create!(name: 'André Vasconcelos', email: 'andre@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    order = Order.create!(warehouse: warehouse, supplier: supplier, user: andre, estimated_delivery_date: 10.days.from_now)

    #Act
    visit edit_order_path(order.id)

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    #Arrange
    andre = User.create!(name: 'André Vasconcelos', email: 'andre@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                      full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
    order = Order.create!(warehouse: warehouse, supplier: supplier, user: andre, estimated_delivery_date: 10.days.from_now)

    #Act
    login_as(andre)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: '12/12/2023'
    select 'Sansung eletronicos Ltda', from: 'Fornecedor'
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Pedido atualizado com sucesso'
    expect(page).to have_content 'Galpão Destino: RIO - Aeroporto RJ'
    expect(page).to have_content 'Fornecedor: Sansung eletronicos Ltda'
    expect(page).to have_content 'Usuário Responsável: André Vasconcelos - andre@example.com'
    expect(page).to have_content "Data Prevista de Entrega: 12/12/2023"
  end

  it 'caso seja o responsável' do
    #Arrange
    andre = User.create!(name: 'André Vasconcelos', email: 'andre@example.com', password: 'password')
    joao = User.create!(name: 'Joao Lima', email: 'joao@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                                        address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    order = Order.create!(warehouse: warehouse, supplier: supplier, user: joao, estimated_delivery_date: 10.days.from_now)

    #Act
    login_as(andre)
    visit edit_order_path(order.id)

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar essa ação!'

  end
end