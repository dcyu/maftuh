class CheckpointsController < ApplicationController
  protect_from_forgery with: :exception
  require 'matrix'

  def index
    @checkpoints = Checkpoint.all
  end

  def new
    @checkpoint = Checkpoint.new
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
    @geo = Geocoder.coordinates(@checkpoint.name)

    @tweets = $twitter.search("to:testmaftuh #{@checkpoint.name}", result_type: "recent")

    if @tweets.count > 0
      @status = @tweets.first.text.include?("open")
      # @checkpoint.update(open: @status)

      data_table = GoogleVisualr::DataTable.new

      # Add Column Headers
      data_table.new_column('string', 'Hour' )
      data_table.new_column('number', 'Open')
      data_table.new_column('number', 'Closed')

      # Add Rows and Values
      grouped_messages = (@tweets.to_a + @checkpoint.messages).group_by{|x| ((Time.now - x.created_at)/3600).round}.sort_by { |time, messages| time }.reverse 


      grouped_messages.reverse_each do |messages|
        open_messages = messages.last.select{|message| message.text.include?("open")}
        closed_messages = messages.last.select{|message| message.text.include?("closed")}

        data_table.add_rows([[
          "#{messages.first} hours ago", open_messages.count, closed_messages.count
        ]]
        )
      end
    end

    option = { width: 400, height: 400, title: 'Recent Status Updates', colors: ['#009900', '#990000'] }
    @chart = GoogleVisualr::Interactive::BarChart.new(data_table, option)

  end

  def edit
    @checkpoint = Checkpoint.find(params[:id])
  end


  def update
    @checkpoint = Checkpoint.find(params[:id])
    if @checkpoint.update(checkpoint_params)
      redirect_to checkpoint_path(@checkpoint), notice: "Checkpoint Updated"
    else
      render action: 'edit'
    end
  end

  def destroy
    @checkpoint = Checkpoint.find(params[:id])
    @checkpoint.destroy
    redirect_to checkpoints_path
  end


  private

  def checkpoint_params
    params.require(:checkpoint).permit(:name, :open)
  end
end
