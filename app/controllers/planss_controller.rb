class PlansController < ApplicationController
  def index
    @q = Plan.ransack(params[:q])
    @plans = @q.result(distinct: true).includes(:user).page(params[:page]).order(created_at: :desc)
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = current_user.plans.build(plan_params)
    if @plan.save
      redirect_to plans_path, success: t("defaults.flash_message.created", item: Plan.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_created", item: Plan.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @plan = Plan.find(params[:id])
  end

  def edit
    @plan = current_user.plans.find(params[:id])
  end

  def update
    @plan = current_user.plans.find(params[:id])
    if @plan.update(plan_params)
      redirect_to plan_path(@plan), success: t("defaults.flash_message.updated", item: Plan.model_name.human)
    else
      flash.now[:danger] = t("defaults.flash_message.not_updated", item: Plan.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    plan = current_user.plans.find(params[:id])
    plan.destroy!
    redirect_to plans_path, success: t("defaults.flash_message.deleted", item: Plan.model_name.human), status: :see_other
  end

  private

  def plan_params
    params.require(:plan).permit(:title, :body, :image, :image_cache)
  end
end
