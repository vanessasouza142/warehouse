class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  def new
    @supplier = Supplier.new
  end

  def create
    #recebo os parâmetros que chegam do formulário
    supplier_params = params.require(:supplier).permit(:corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email)
    #criar o objetos no banco de dados
    @supplier = Supplier.new(supplier_params)
    #redireciono
    if @supplier.save
      redirect_to suppliers_path, notice: 'Fornecedor cadastrado com sucesso'
    else
      flash.now[:notice] = 'Fornecedor não cadastrado'
      render 'new'
    end
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
    #obtenho o objeto
    @supplier = Supplier.find(params[:id])
    #recebo os parâmetros que chegam do formulário
    supplier_params = params.require(:supplier).permit(:corporate_name, :brand_name, :registration_number, :full_address, :city, :state, :email)
    #redireciono
    if @supplier.update(supplier_params)
      redirect_to supplier_path(@supplier.id), notice: 'Fornecedor atualizado com sucesso'
    else
      flash.now[:notice] = 'Não foi possível atualizar o fornecedor'
      render 'edit'
    end
  end
end