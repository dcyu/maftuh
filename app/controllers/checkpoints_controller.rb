class CheckpointsController < ApplicationController
  protect_from_forgery with: :exception

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

      @open_tweets = @tweets.select{|tweet| tweet.text.include?("open")}
      @closed_tweets = @tweets.select{|tweet| tweet.text.include?("closed")}

      data_table = GoogleVisualr::DataTable.new

      # Add Column Headers
      data_table.new_column('string', 'Hour' )
      data_table.new_column('number', 'Open')
      data_table.new_column('number', 'Closed')

      # Add Rows and Values
      grouped_tweets = @tweets.group_by{|x| x.created_at.strftime("%Y-%m-%d-%H")} 

      grouped_tweets.reverse_each do |tweets|
        open_tweets = tweets.last.select{|tweet| tweet.text.include?("open")}
        closed_tweets = tweets.last.select{|tweet| tweet.text.include?("closed")}

        data_table.add_rows([[
          (Time.parse(tweets.first) + tweets.first.split('-').last.to_i.hours).to_formatted_s(:long), open_tweets.count, closed_tweets.count
        ]]
        )
      end
    end

    option = { width: 400, height: 200, title: 'Recent Status Updates', colors: ['#009900', '#990000'] }
    @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, option)

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
