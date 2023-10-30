require 'rails_helper'

describe 'Usuário edita um pedido' do
  it 'e não é o dono' do
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
    #realizando requizicao http do tipo patch com um fornecedor que nao existe
    patch(order_path(order.id), params: { order: { supplier_id: 3}})

    #Assert
    expect(response).to redirect_to(root_path)

  end
end