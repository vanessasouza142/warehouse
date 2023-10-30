require 'rails_helper'

describe 'Usuário faz login' do
  it 'com sucesso' do
    #Arrange
    User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')

    #Act
    visit root_path
    within('nav') do
      click_on 'Entrar na Conta'
    end
    fill_in 'E-mail', with: 'vanessa@gmail.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    #Assert
    expect(page).to have_content 'Login efetuado com sucesso'
    within('nav') do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Vanessa Souza - vanessa@gmail.com'
    end
  end

  it 'e faz logout' do
    #Arrange
    User.create!(name: 'Vanessa Souza', email: 'vanessa@gmail.com', password: 'password')

    #Act
    visit root_path
    within('nav') do
      click_on 'Entrar na Conta'
    end
    fill_in 'E-mail', with: 'vanessa@gmail.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'
    click_on 'Sair'

    #Assert
    expect(page).to have_content 'Logout efetuado com sucesso'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'vanessa@gmail.com'
  end
end