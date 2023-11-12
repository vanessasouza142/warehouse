require 'rails_helper'

describe 'Warehouse API' do
  context 'GET/api/v1/warehouses/1' do #endpoint ver detalhes de um galpão (show)
    it 'com sucesso' do
      #Arrange
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                    address: 'Avenida do Aeroporto, 1000', cep: '15000-000', 
                                    description: 'Galpão destinado para cargas internacionais')

      #Act
      #requisição http (verbo e url)
      get "/api/v1/warehouses/#{warehouse.id}"

      #Assert
      #resposta http (status e typo de conteúdo e conteúdo da resposta)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Aeroporto SP')
      expect(json_response['code']).to eq('GRU')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'falha se um galpão não é encontrado' do
      #Arrange

      #Act
      get "/api/v1/warehouses/99999999"

      #Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET/api/v1/warehouses' do #endpoint ver listagem de todos os galpões (index)
    it 'lista todos os galpões ordenados alfabeticamente' do
      #Arrange
      Warehouse.create!(name: 'Rio de Janeiro', code: 'SDU', city: 'Rio de Janeiro', area: 60_000, address:'Av. do Porto, 1000', 
                        cep: '20000-000', description: 'Galpão do Rio')
      Warehouse.create!(name: 'Maceio', code: 'MCZ', city: 'Maceio', area: 50_000, address: 'Av. do Mar, 3080',
                        cep: '45000-000', description: 'Galpão de Maceió')

      #Act
      get '/api/v1/warehouses'

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Maceio'
      expect(json_response[1]['name']).to eq 'Rio de Janeiro'
      expect(json_response[0].keys).not_to include 'created_at'
      expect(json_response[1].keys).not_to include 'updated_at'
    end

    it 'retorna vazio se nenhum galpão é encontrado' do
      #Arrange

      #Act
      get '/api/v1/warehouses'

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'falha se tiver um erro interno' do
      #Arrange
      allow(Warehouse).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      #Act
      get '/api/v1/warehouses'

      #Assert
      expect(response.status).to eq 500
    end
  end

  context 'POST/api/v1/warehouses' do #endpoint para criar um galpão (create)
    it 'com sucesso' do
      #Arrange
      #payload
      warehouse_params = { warehouse: { name: 'Galpão Belo Horizonte', code: 'BEL', city: 'Belo Horizonte', area: 150_000, 
                                        address: 'Avenida Principal, 1000', cep: '45000-000', description: 'Galpão de belo horizonte'}
                          }

      #Act
      post '/api/v1/warehouses', params: warehouse_params

      #Assert
      #expect(response.status).to eq 201 ou
      expect(response).to have_http_status(201)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Galpão Belo Horizonte')
      expect(json_response['code']).to eq('BEL')
      expect(json_response['city']).to eq('Belo Horizonte')
      expect(json_response['area']).to eq(150_000)
      expect(json_response['address']).to eq('Avenida Principal, 1000')
      expect(json_response['cep']).to eq('45000-000')
      expect(json_response['description']).to eq('Galpão de belo horizonte')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'falha se parametros não estão completos' do
      #Arrange
      warehouse_params = { warehouse: { name: 'Galpão Belo Horizonte', code: 'BEL'}
                          }

      #Act
      post '/api/v1/warehouses', params: warehouse_params

      #Assert
      expect(response).to have_http_status(412)
      expect(response.content_type).to include 'application/json'
      expect(response.body).not_to include 'Nome não pode ficar em branco'
      expect(response.body).not_to include 'Código não pode ficar em branco'
      expect(response.body).to include 'Cidade não pode ficar em branco'
      expect(response.body).to include 'Área não pode ficar em branco'
      expect(response.body).to include 'Endereço não pode ficar em branco'
      expect(response.body).to include 'CEP não pode ficar em branco'
      expect(response.body).to include 'Descrição não pode ficar em branco'
    end

    it 'falha se tiver um erro interno' do
      #Arrange
      warehouse_params = { warehouse: { name: 'Galpão Belo Horizonte', code: 'BEL', city: 'Belo Horizonte', area: 150_000, 
                                        address: 'Avenida Principal, 1000', cep: '45000-000', description: 'Galpão de belo horizonte'}
                          }
      #mocks - simular uma ação no teste (no caso, quero simular que vai ocorrer algum erro ao criar um galpão. O rails trata erros por 
      #exemplo de banco de dados, de servidor, etc..mas nesses teste quero forçar que alguns desses erros podem acontecer)
      allow(Warehouse).to receive(:new).and_raise(ActiveRecord::ActiveRecordError) 
      #estou simulando que quando acontecer o warehouse.new, vai ocorrer um erro na aplicação

      #Act
      post '/api/v1/warehouses', params: warehouse_params

      #Assert
      expect(response).to have_http_status(500)
    end
  end
end