require 'rails_helper'

describe 'Usuário edita informações do fornecedor' do
  it 'a partir da página de detalhes' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
    #Act
    visit root_path
    within('nav') do
      click_on('Fornecedores')
    end
    click_on('Sapatos e Cia')
    click_on('Editar')
    #Assert
    expect(page).to have_content('Editar Fornecedor')
    expect(page).to have_field('Nome Fantasia', with: 'Shoes Ltda')
    expect(page).to have_field('Razão Social', with: 'Sapatos e Cia')
    expect(page).to have_field('CNPJ', with: '4561')
    expect(page).to have_field('Endereço', with: 'Av. Paulista, 6000')
    expect(page).to have_field('Cidade', with: 'São Paulo')
    expect(page).to have_field('Estado', with: 'SP')
    expect(page).to have_field('Email', with: 'sapatosecia@gmail.com')
  end

  it 'com sucesso' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com') 

    #Act
    visit root_path
    within('nav') do
    click_on('Fornecedores')
    end
    click_on('Sapatos e Cia')
    click_on('Editar')
    fill_in('Razão Social', with: 'Sapatos Couro e Cia')
    fill_in('CNPJ', with: '468975514545')
    fill_in('Endereço', with: 'Av. Paulista, 6080')
    click_on('Enviar')

    #Assert
    expect(page).to have_content('Fornecedor atualizado com sucesso')
    expect(page).to have_content('Fornecedor: Sapatos Couro e Cia')
    expect(page).to have_content('CNPJ: 468975514545')
    expect(page).to have_content('Endereço: Av. Paulista, 6080')
  end

  it 'e mantém so campos obrigatórios' do
    #Arrange
    supplier = Supplier.create!(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com') 
    #Act
    visit suppliers_path
    click_on('Sapatos e Cia')
    click_on('Editar')
    fill_in('Nome Fantasia', with: '')
    fill_in('Razão Social', with: '')
    fill_in('CNPJ', with: '')
    click_on('Enviar')

    #Assert
    expect(page).to have_content('Não foi possível atualizar o fornecedor')
    expect(page).to have_content('Nome Fantasia não pode ficar em branco')
    expect(page).to have_content('Razão Social não pode ficar em branco')
    expect(page).to have_content('CNPJ não pode ficar em branco')

  end
end