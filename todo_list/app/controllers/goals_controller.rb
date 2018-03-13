class GoalsController < ApplicationController
  def index
    @goals = Goal.all
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def create
    goal = Goal.new(goal_params)
    goal.user_id = current_user.id
    if goal.save
      redirect_to goal_url(goal)
    else
      flash[:errors] = goal.errors.full_messages
      render :new
    end
  end

  def update
    goal = Goal.find(params[:id])
    goal.user_id = current_user.id

    if goal.update_attributes(goal_params)
      redirect_to goal_url(goal)
    else
      flash[:errors] = goal.errors.full_messages
      render :edit
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  private

  def goal_params
    params.require(:goal).permit(:task, :body)
  end
end
