require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'falso quando Nome Fantasia está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: '', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
        #Act
        result = supplier.valid?
        #Assert
        expect(result).to eq false
      end

      it 'falso quando Razão Social está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: 'Shoes Ltda', brand_name: '', registration_number: '4561',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
        #Act

        #Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando CNPJ está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
        #Act

        #Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando Endereço está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                    full_address: '', city: 'São Paulo', state: 'SP', email: 'sapatosecia@gmail.com')
        #Act

        #Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando Cidade está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                    full_address: 'Av. Paulista, 6000', city: '', state: 'SP', email: 'sapatosecia@gmail.com')
        #Act

        #Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando Estado está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: '', email: 'sapatosecia@gmail.com')
        #Act

        #Assert
        expect(supplier).not_to be_valid
      end

      it 'falso quando Email está vazio' do
        #Arrange
        supplier = Supplier.new(corporate_name: 'Shoes Ltda', brand_name: 'Sapatos e Cia', registration_number: '4561',
                                    full_address: 'Av. Paulista, 6000', city: 'São Paulo', state: 'SP', email: '')
        #Act

        #Assert
        expect(supplier).not_to be_valid
      end
    end
  end
end
