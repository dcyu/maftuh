class CheckpointsController < ApplicationController
  protect_from_forgery with: :exception

  def index
    @checkpoints = Checkpoint.all
  end

  def new
    @checkpoint = Checkpoint.new
  end

  def create
  end

  def create
    @checkpoint = Checkpoint.new(checkpoint_params)

    if @checkpoint.save
      redirect_to checkpoint_path(@checkpoint), notice: "Checkpoint created"
    else
      render action: 'new'
    end
  end

  def show
    @checkpoint = Checkpoint.find(params[:id])
  end


  private

  def checkpoint_params
    params.require(:checkpoint).permit(:name, :open)
  end
end
