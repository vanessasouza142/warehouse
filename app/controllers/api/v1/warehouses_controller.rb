class Api::V1::WarehousesController < Api::V1::ApiController

  def show
    #warehouse = Warehouse.find(params[:id]) #quando o id não é encontrado, dispara um erro
    #warehouse = Warehouse.find_by(id: params[:id]) #encontre o galpão que tenha o id x; quando não encontra, devolve nil
    warehouse = Warehouse.find(params[:id])
    render status: 200, json: warehouse.as_json(except: [:created_at, :updated_at])
  end

  def index
    warehouses = Warehouse.all.order(:name)
    render status: 200, json: warehouses.as_json(except: [:created_at, :updated_at])
  end

  def create
    warehouse_params = params.require(:warehouse).permit(:name, :code, :city, :area, :address, :cep, :description)
    warehouse = Warehouse.new(warehouse_params)
    if warehouse.save
      render status: 201, json: warehouse.as_json(except: [:created_at, :updated_at])
    else
      render status: 412, json: { errors: warehouse.errors.full_messages }
    end
  end

end