require 'rails_helper'

describe 'Usuário vẽ modelos de produtos' do
  it 'se estiver autenticado' do
    #Arrange

    #Act
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    #Assert
    #espera que o devise lhe direcione para a tela de login
    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    #Arrange
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')
    #Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    #Assert
    expect(current_path).to eq product_models_path
  end

  it 'com sucesso' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                                full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
    ProductModel.create!(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SANSU-XPTO90', supplier: supplier)
    ProductModel.create!(name: 'TV 50', weight: 12000, width: 120, height: 60, depth: 18, sku: 'TV50-SANSU-TRESO90', supplier: supplier)
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    #Assert
    expect(page).to have_content('TV 32')
    expect(page).to have_content('TV32-SANSU-XPTO90')
    expect(page).to have_content('Sansung')

    expect(page).to have_content('TV 50')
    expect(page).to have_content('TV50-SANSU-TRESO90')
    expect(page).to have_content('Sansung')
  end

  it 'e não existem produtos cadastrados' do
    #Arrange
    user = User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')

    #Act
    login_as(user)
    visit root_path
    within('nav') do
      click_on 'Modelos de Produtos'
    end

    #Assert
    expect(current_path).to eq product_models_path
    expect(page).to have_content('Não existem modelos de produtos cadastrados')
  end
end