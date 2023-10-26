class ProductModelsController < ApplicationController
  def index
    @product_models = ProductModel.all
  end

  def new
    @product_model = ProductModel.new
    @suppliers = Supplier.all
  end

  def create
    product_model_params = params.require(:product_model).permit(:name, :weight, :width, :height, :depth, :sku, :supplier_id)
    @product_model = ProductModel.new(product_model_params)
    if @product_model.save
      redirect_to @product_model, notice: 'Modelo de produto cadastrado com sucesso'
      # ou pode passar o proprio objeto:
      # redirect_to @product_model, notice: 'Modelo de produto cadastrado com sucesso'
    else
      #é necessario declarar a variavel @suppliers para ser usada no complete_select do formulário
      @suppliers = Supplier.all
      flash.now[:notice] = 'Modelo de produto não cadastrado'
      render 'new'
    end
  end

  def show
    @product_model = ProductModel.find(params[:id])
  end
end