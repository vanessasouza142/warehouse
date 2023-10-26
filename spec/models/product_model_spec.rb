require 'rails_helper'

RSpec.describe ProductModel, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'name is mandatory' do
        #Arrange
        supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
        pm = ProductModel.new(name: '', weight: 8000, width: 70, height: 45, depth: 10, sku: 'TV32-SANSU-XPTO90', supplier: supplier)
        #Act
        result = pm.valid?
        #Assert
        expect(result).to eq false
      end

      it 'sku is mandatory' do
        #Arrange
        supplier = Supplier.create!(corporate_name: 'Sansung eletronicos Ltda', brand_name: 'Sansung', registration_number: '4578987545',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sac@sansung.com.br')
        pm = ProductModel.new(name: 'TV 32', weight: 8000, width: 70, height: 45, depth: 10, sku: '', supplier: supplier)
        #Act
        result = pm.valid?
        #Assert
        expect(result).to eq false
      end
    end
  end
end
