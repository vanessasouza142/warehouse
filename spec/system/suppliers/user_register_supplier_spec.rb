require 'rails_helper'

describe 'Usuário cadastra novo fornecedor' do
  it 'a partir da tela de inicial' do
    #Arrange

    #Act
    visit root_path
    within('nav') do
      click_on('Fornecedores')
    end
    click_on('Cadastrar fornecedor')

    #Assert
    expect(page).to have_field('Nome Fantasia')
    expect(page).to have_field('Razão Social')
    expect(page).to have_field('CNPJ')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('Estado')
    expect(page).to have_field('Email')
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
    click_on('Cadastrar fornecedor')
    fill_in('Nome Fantasia', with: 'Shoes Ltda')
    fill_in('Razão Social', with: 'Sapatos e Cia')
    fill_in('CNPJ', with: '4561')
    fill_in('Endereço', with: 'Av. Paulista, 6000')
    fill_in('Cidade', with: 'São Paulo')
    fill_in('Estado', with: 'SP')
    fill_in('Email', with: 'sapatosecia@gmail.com')
    click_on('Enviar')

    #Assert
    expect(current_path).to eq suppliers_path
    expect(page).to have_content('Fornecedor cadastrado com sucesso')
    expect(page).to have_content('Sapatos e Cia')
    expect(page).to have_content('São Paulo - SP')
  end

  it 'com dados incompletos' do
    #Arrange

    #Act
    visit suppliers_path
    click_on('Cadastrar fornecedor')
    fill_in('Nome Fantasia', with: '')
    fill_in('Razão Social', with: '')
    fill_in('CNPJ', with: '')
    click_on('Enviar')

    #Assert
    expect(page).to have_content('Fornecedor não cadastrado')
    expect(page).to have_content('Nome Fantasia não pode ficar em branco')
    expect(page).to have_content('Razão Social não pode ficar em branco')
    expect(page).to have_content('CNPJ não pode ficar em branco')
  end
end