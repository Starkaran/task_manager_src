class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:update, :destroy]
  
  def index
    @tasks = current_user.tasks
    authorize @tasks
    render json: @tasks, each_serializer: TaskSerializer, status: :ok
  end

  def create
    if calculate_count
      render json: { message: 'Cannot create new To Do task' }, status: :unprocessable_entity
      return
    end
    @task = current_user.tasks.build(task_params)
    authorize @task

    if @task.save
      render json: @task, serializer: TaskSerializer, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @task

    if @task.update(task_params)
      render json: @task, serializer: TaskSerializer, status: :ok
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @task
    @task.destroy
    head :no_content
  end

  def sort_by_due_date
    @tasks = current_user.tasks.sorted_by_due_date
    render_tasks_json
  end

  def search
    @tasks = current_user.tasks.search_by_title(params[:query])
    render_tasks_json
  end

  private

  def set_task
    @task = Task.find(params[:id])
  rescue
    render json: { message: 'Task not found' }, status: :not_found
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end

  def calculate_count
    return false if task_params[:status] != 'To Do'
    
    tasks = current_user.tasks
    todo_tasks_count = tasks.where(status: 'To Do').count
    (todo_tasks_count / tasks.count.to_f) >= 0.5
  end

  def render_tasks_json
    if @tasks.present?
      render json: @tasks, each_serializer: TaskSerializer, status: :ok
    else
      render json: { message: 'No tasks found' }, status: :not_found
    end
  end
end