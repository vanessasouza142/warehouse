require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'código deve ser obrigatório' do
      #Arrange
      user = User.create!(name: 'Beatriz Silva', email: 'beatriz@gmail.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                        full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 10.days.from_now)

      #Act
      result = order.valid?

      #Assert
      expect(result).to be true
    end

    it 'data estimada de entrega deve ser obrigatório' do
      #Arrange
      order = Order.new(estimated_delivery_date: '')

      #Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)

      #Assert
      expect(result).to be true
    end

  it 'data estimada de entrega não pode estar no passado' do
    #Arrange
    order = Order.new(estimated_delivery_date: 5.days.ago)

    #Act
    order.valid?

    #Assert
    expect(order.errors.include?(:estimated_delivery_date)).to be true
    expect(order.errors[:estimated_delivery_date]).to include(" deve ser futura.")
  end

  it 'data estimada de entrega não pode ser igual a hoje' do
    #Arrange
    order = Order.new(estimated_delivery_date: Date.today)

    #Act
    order.valid?

    #Assert
    expect(order.errors.include?(:estimated_delivery_date)).to be true
    expect(order.errors[:estimated_delivery_date]).to include(" deve ser futura.")
  end

  it 'data estimada de entrega deve ser igual ou maior do que amanhã' do
    #Arrange
    order = Order.new(estimated_delivery_date: 1.day.from_now)

    #Act
    order.valid?

    #Assert
    expect(order.errors.include?(:estimated_delivery_date)).to be false
  end
end

  describe 'É gerado um código aleatório' do
    it 'ao realizar um pedido' do
      #Arrange
      user = User.create!(name: 'Beatriz Silva', email: 'beatriz@gmail.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                        full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 5.days.from_now)

      #Act
      result = order.code

      #Assert
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'com valor único' do
      #Arrange
      user = User.create!(name: 'Beatriz Silva', email: 'beatriz@gmail.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'LG eletronicos Ltda', brand_name: 'LG', registration_number: '548746548784',
                        full_address: 'Av. Ibirapuera, 300', city: 'São Paulo', state: 'SP', email: 'sac@lg.com.br')
      first_order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)
      second_order = Order.new(user: user, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.month.from_now)

      #Act
      second_order.save!

      #Assert
      expect(second_order.code).not_to eq first_order.code
    end
  end
end
