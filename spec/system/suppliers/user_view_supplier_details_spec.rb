require 'rails_helper'

describe 'Usuário vê detalhes de um fornecedor' do
  it 'a partir da tela inicial' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                      full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
    
    #Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end
    click_on 'Sapatos e Cia'

    #Assert
    expect(page).to have_content('Shoes Ltda')
    expect(page).to have_content('CNPJ: 4561')
    expect(page).to have_content('Endereço: Av. Paulista, 6000, São Paulo - SP')
    expect(page).to have_content('Email: sapatosecia@gmail.com')
  end

  it 'e retorna para tela inicial' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                      full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
    
    #Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end
    click_on 'Sapatos e Cia'
    expect(page).to have_content('Shoes Ltda')
    expect(page).to have_content('CNPJ: 4561')
    expect(page).to have_content('Endereço: Av. Paulista, 6000, São Paulo - SP')
    expect(page).to have_content('Email: sapatosecia@gmail.com')
    click_on 'Voltar'

    #Assert
    expect(current_path).to eq root_path
  end
end