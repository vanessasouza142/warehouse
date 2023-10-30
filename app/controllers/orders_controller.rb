class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order_and_check_user, only: [:show, :edit, :update]

  def index
    #mostrar os pedidos do usuário logado
    @orders = current_user.orders
  end

  def new
    @order = Order.new
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def create
    order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.save
      redirect_to @order, notice: 'Pedido registrado com sucesso'
      #fazendo @order, estou passando o objeto, logo o rails vai ecaminhar para o show do objeto
    else
      @warehouses = Warehouse.all
      @suppliers = Supplier.all
      flash.now[:notice] = 'Pedido não registrado'
      render 'new'
    end
  end

  def show
  end

  def search
    @code = params["query"]
    # @order = Order.find_by(code: @code)
    @orders = Order.where("code LIKE ?", "%#{@code}%")
  end

  def edit
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def update
    order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
    if @order.update(order_params)
      redirect_to @order, notice: 'Pedido atualizado com sucesso'
    else
      @warehouses = Warehouse.all
      @suppliers = Supplier.all
      flash.now[:notice] = 'Pedido não atualizado'
      render 'edit'
    end
  end

  private

  def set_order_and_check_user
    @order = Order.find(params[:id])
    if @order.user != current_user
      return redirect_to root_path, alert: 'Você não tem permissão para realizar essa ação!'
    end
  end
end