class GoalsController < ApplicationController

  before_action :ensure_logged_in, except: [:index, :show]

  def index
    @goals = Goal.where(user_id: params[:id])
    render :index
  end

  def show
    @goal = Goal.find_by_id(params[:id])
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user_id = current_user.id
    if @goal.save
      redirect_to goal_url(@goal)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
    @goal = Goal.find_by_id(params[:id])
  end

  def update
    @goal = Goal.find_by_id(params[:id])
    if current_user.id == @goal.user_id
      if @goal.update(goal_params)
        redirect_to goal_url(@goal)
      else
        flash.now[:errors] = @goal.errors.full_messages
        render :edit
      end
    else
      flash[:errors] = ['You can\'t edit someone else\'s goals']
      redirect_to goal_url(@goal)
    end
  end

  def destroy
    @goal = Goal.find_by_id(params[:id])
    if current_user.id != @goal.user_id
      redirect_to goal_url(@goal)
    else
      @goal.delete
      redirect_to user_url(@goal.user_id)
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:title, :details, :private, :completed)
  end

end
