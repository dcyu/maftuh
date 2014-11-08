class CheckpointsController < ApplicationController
  protect_from_forgery with: :exception

  def index
    @checkpoints = Checkpoint.all
  end

  def checkpoint
    @checkpoint = params[:name]
    @status = params[:status]
  end
end
