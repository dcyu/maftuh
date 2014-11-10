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
    if @checkpoint.nil?
      redirect_to checkpoints_path
    end
    @geo = Geocoder.coordinates(@checkpoint.name)

    @tweets = $twitter.search("to:testmaftuh #{@checkpoint.name}", result_type: "recent")
    @all_messages = (@tweets.to_a + @checkpoint.messages).sort_by(&:created_at).reverse

    if @all_messages.count > 0

      data_table = GoogleVisualr::DataTable.new

      # Add Column Headers
      data_table.new_column('string', 'Hour' )
      data_table.new_column('number', 'Open')
      data_table.new_column('number', 'Closed')

      # Add Rows and Values
      grouped_messages = (@all_messages).group_by { |m| ((Time.now - m.created_at) / 3600).round }.sort_by { |time| time }.reverse

      grouped_messages.each do |messages|
        open_messages = messages.last.select{|message| message.text.include?('open')}
        closed_messages = messages.last.select{|message| message.text.include?('closed')}

        if grouped_messages.first == messages
          if open_messages.count > closed_messages.count
            @checkpoint.update(open: true)
          elsif closed_messages.count > open_messages.count
            @checkpoint.update(open: false)
          end
        end

        label = messages.first.to_i == 1 ? "#{messages.first} hour ago" : "#{messages.first} hours ago"

        data_table.add_rows([[
          label, open_messages.count, closed_messages.count
        ]]
        )
      end
      option = {fontSize: 15, width: 530, height: 530, title: 'Recent Status Updates', colors: ['#009900', '#990000'], hAxis: {viewWindowMode: 'pretty'} }
      @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, option)
    end
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
