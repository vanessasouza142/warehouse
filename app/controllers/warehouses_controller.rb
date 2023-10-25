class WarehousesController < ApplicationController
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  def show;  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    #Aqui dentro que nós vamos:
    # 1-Receber os dados enviados/Receber os parâmetros que estão chegando do formulário
    # 2-Criar um novo galpão no banco de dados
    # 3-Redirecionar para a tela inicial  
    @warehouse = Warehouse.new(warehouse_params)
    if @warehouse.save #roda o método valid? e verifica se tem algum error. Se não tiver erro, salva no banco de dados.
      redirect_to root_path, notice: 'Galpão cadastrado com sucesso' # ou flash[:notice] = 'Galpão cadastrado com sucesso'
    else
      flash.now[:notice] = 'Galpão não cadastrado' # o render não tem o atalho do redirect_to
      render 'new' 
    end
  end

  def edit
  end

  def update
    # 1-Obter o objeto
    # 2-Receber os parâmetros que estão chegando do formulário e atualizar no banco de dados
    # 3-Redirecionar para o show(detalhes do galpão)
    set_warehouse
    if @warehouse.update(warehouse_params)
      redirect_to warehouse_path(@warehouse.id), notice: 'Galpão atualizado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível atualizar o galpão'
      render 'edit'
    end
  end

  def destroy
    @warehouse
    @warehouse.destroy
    redirect_to root_path, notice: 'Galpão removido com sucesso'
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:name, :code, :city, :description, :address, :cep, :area) #Strong Parameters
  end
end