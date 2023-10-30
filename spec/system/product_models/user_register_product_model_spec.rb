require 'rails_helper'

describe 'Usuário cadastra modelo de produto' do
  it 'com sucesso' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                                full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
    other_supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                                full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar modelo de produto'
    fill_in 'Nome', with: 'TV 32 Polegadas'
    fill_in 'Peso', with: 10_000
    fill_in 'Largura', with: 60
    fill_in 'Altura', with: 90
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV32-SANSU-XPTO90'
    select 'Sansung', from: 'Fornecedor'
    click_on 'Enviar'

    #Assert
    expect(page).to have_content('Modelo de produto cadastrado com sucesso')
    expect(page).to have_content('TV 32 Polegadas')
    expect(page).to have_content('Fornecedor: Sansung')
    expect(page).to have_content('SKU: TV32-SANSU-XPTO90')
    expect(page).to have_content('Dimensões: 60cm x 90cm x 10cm')
    expect(page).to have_content('Peso: 10000g')
  end

  it 'edeve preencher todos os campos' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar modelo de produto'
    fill_in 'Nome', with: ''
    fill_in 'SKU', with: ''
    click_on 'Enviar'

    #Assert
    expect(page).to have_content('Modelo de produto não cadastrado')
  end
end