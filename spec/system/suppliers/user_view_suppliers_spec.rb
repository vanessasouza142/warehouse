require 'rails_helper'

describe 'Usuário vê fornecedores' do
  it 'a partir do menu' do
    #Arrange

    #Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end

    #Assert
    expect(current_path).to eq suppliers_path
  end

  it 'com sucesso' do
    #Arrange
    first_supplier = Supplier.create!(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                      full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
    second_supplier = Supplier.create!(corporate_name: 'Tapawares Ltda', brand_name: 'Potes e cia', registration_number: '7845',
                                      full_address: 'Av. da fabrica, 8000', city: 'Rio de Janeiro', state: 'RJ', email: 'potesecia@gmail.com')

    #Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end

    #Assert
    expect(current_path).to eq suppliers_path
    expect(page).to have_content('Sapatos e Cia')
    expect(page).to have_content('São Paulo - SP')
    expect(page).to have_content('Potes e cia')
    expect(page).to have_content('Rio de Janeiro - RJ')
    expect(page).not_to have_content('Não existem galpões cadastrados')
  end
end