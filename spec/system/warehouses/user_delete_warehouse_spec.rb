require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    #Arrange
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')

    #Act
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Remover'

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Galpão removido com sucesso')
    expect(page).not_to have_content('Aeroporto SP')
    expect(page).not_to have_content('GRU')
    expect(page).not_to have_content('100000 m2')
  end

  it 'e nao remove outros galpões' do
    #Arrange
    first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                        address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    second_warehouse = Warehouse.create!(name: 'Aeroporto RJ', code: 'RIO', city: 'Rio de Janeiro', area: 150_000,
                                        address: 'Avenida dos Galpões, 800', cep: '45000-000', description: 'Galpão do Rio de Janeiro')

    #Act
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Remover'

    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content('Galpão removido com sucesso')
    expect(page).not_to have_content('Aeroporto SP')
    expect(page).not_to have_content('GRU')
    expect(page).to have_content('Aeroporto RJ')
    expect(page).to have_content('RIO')
  end
end