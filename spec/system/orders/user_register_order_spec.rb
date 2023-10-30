require 'rails_helper'

describe 'Usuário cadastra um pedido' do
  it 'e deve estar autenticado' do
    #Arrange

    #Act
    visit root_path
    click_on 'Registrar Pedido'

    #Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')
    Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                      address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                                full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
    #Permita que a classe SecureRandom receba o metodo alphanumeric com o parametro (8) e retorne 'ABC12345'
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    #Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: 1.day.from_now
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'Pedido: ABC12345'
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: Sansung eletronicos Ltda'
    expect(page).to have_content 'Usuário Responsável: Vanessa Souza - vanessa@gmail.com'
    expect(page).to have_content "Data Prevista de Entrega: #{I18n.l(1.day.from_now, format: "%d/%m/%Y")}"
    expect(page).not_to have_content 'Aeroporto RJ'
    expect(page).not_to have_content 'LG eletronicos Ltda'
  end

  it 'e não informa a data de entrega' do
    #Arrange
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')
    Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 50_000,
                      address: 'Avenida dos Galpões, 1000', cep: '45000-000', description: 'Galpão do Rio de Janeiro')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                      full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                                full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
    #Permita que a classe SecureRandom receba o metodo alphanumeric com o parametro (8) e retorne 'ABC12345'
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABC12345')
    #Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista de Entrega', with: ''
    click_on 'Salvar'

    #Assert
    expect(page).to have_content 'Pedido não registrado'
    expect(page).to have_content 'Data Prevista de Entrega não pode ficar em branco'
  end

  #realizar mais um teste
  # it 'e data prevista de entrega está no passado'
end