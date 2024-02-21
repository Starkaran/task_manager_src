class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = current_user.tasks
    authorize @tasks
    render json: @tasks, each_serializer: TaskSerializer, status: :ok
  end

  def show
    authorize @task
    render json: @task, serializer: TaskSerializer, status: :ok
  end

  def new
    @task = Task.new
    authorize @task
    render json: @task, serializer: TaskSerializer, status: :ok
  end

  def create
    @task = current_user.tasks.build(task_params)
    authorize @task

    if @task.save
      render json: @task, serializer: TaskSerializer, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def edit
    authorize @task
    render json: @task, serializer: TaskSerializer, status: :ok
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
  end

  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end

  def render_tasks_json
    if @tasks.present?
      render json: @tasks, each_serializer: TaskSerializer, status: :ok
    else
      render json: { message: 'No tasks found' }, status: :not_found
    end
  end
end