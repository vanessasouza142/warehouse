require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'false when name is empty' do
        #Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Endereço', cep: '25000-000', city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        # result = warehouse.valid?
        #Assert
        # expect(result).to be_falsey
        expect(warehouse).not_to be_valid #executa o valid e espera que seja falso
      end

      it 'false when code is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Endereço', cep: '25000-000', city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false
      end

      it 'false when address is empty' do
        #Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '', cep: '25000-000', city: 'Rio', area: 1000, description: 'Alguma descrição')
        #Act
        result = warehouse.valid?
        #Assert
        expect(result).to eq false
      end
    end

    context 'uniqueness' do
      it 'false when code is already in use' do
        #Arrange
        first_warehouse = Warehouse.create(name: 'Rio de Janeiro', code: 'RIO', address: 'Endereço', cep: '25000-000', city: 'Rio', area: 1000, description: 'Alguma descrição')
        second_warehouse = Warehouse.new(name: 'Niteroi', code: 'RIO', address: 'Endereço tal', cep: '35000-000', city: 'Niteroi', area: 2000, description: 'Alguma outra descrição')
        #Act
        result = second_warehouse.valid?

        #Assert
        expect(result).to eq false
      end
    end
  end

  describe '#full_description' do
    it 'exibits name and code' do
      #Arrange
      w = Warehouse.new(name: 'Galpão Cuiabá', code: 'CBA')

      #Act
      result = w.full_description

      #Assert
      expect(result).to eq('CBA - Galpão Cuiabá')

    end
  end
end
