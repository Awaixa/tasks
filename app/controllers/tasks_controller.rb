class TasksController < ApplicationController
  def index
    render json: Task.all,
           each_serializer: TaskSerializer,
           status: :ok
  end

  def show
    render json: Task.find_by!(uuid: params[:id]),
           serializer: TaskSerializer,
           status: :ok
  end

  def create
    task = Task.new(permit_params)
    task.save!

    render json: task,
           serializer: TaskSerializer,
           status: :created
  end

  private

  def permit_params
    params
      .fetch(:data, {})
      .fetch(:attributes, {})
      .permit(
        :name,
        :description,
        :category,
        :priority,
      )
  end
end
