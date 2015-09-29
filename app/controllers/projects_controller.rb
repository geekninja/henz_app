class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show

    if params[:search].present?
      @begin_month  = Date.parse(params[:search][:start_date].to_s)
      @end_month    = Date.parse(params[:search][:end_date].to_s)
    else
      @begin_month  = Date.today.beginning_of_month.strftime('%d/%m/%Y')
      @end_month    = Date.today.end_of_month.strftime('%d/%m/%Y')
    end

    @project_funds   = @project.project_funds.where(date_payment: @begin_month.strftime('%Y-%m-%d')..@end_month.strftime('%Y-%m-%d'))
    @project_finance = @project.project_finances.where(date: @begin_month.strftime('%Y-%m-%d')..@end_month.strftime('%Y-%m-%d'))
    @pays            = @project.pays.where(deadline: @begin_month.strftime('%Y-%m-%d')..@end_month.strftime('%Y-%m-%d'), status: false)
    @receipts        = @project.receipts.where(deadline: @begin_month.strftime('%Y-%m-%d')..@end_month.strftime('%Y-%m-%d'), status: false)
    @fuels           = @project.fuel_expenses.where(date: @begin_month.strftime('%Y-%m-%d')..@end_month.strftime('%Y-%m-%d'))
    @uploads         = @project.archives.limit(10).order('created_at DESC')
            
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(set_params)

    if @project.save
      redirect_to action: 'index'
      flash[:success] = t :success
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(set_params)
      flash[:success] = t :success
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    if @project.destroy
        flash[:success] = t :success
        redirect_to action: 'index'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def set_params
      params.require(:project).permit(:project_category_id, :name, :local, :responsible_id, :geolocation, :description, :observation, :priority)
    end
end
