class MessagesController < ApplicationController
  include ActionController::Live
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  REPEAT = 1

  def stream
    @messages = Message.all
    Rails.logger.debug("started stream")
    response.headers['Content-Type'] = 'text/event-stream'
    repeat = REPEAT
    if params[:times].present?
      repeat = params[:times].to_i
    end
    repeat.times {
      @messages.each do |message|
        response.stream.write message.as_json.to_s
      end
    }
    # 10.times do |i|
    #   Rails.logger.debug("streaming")
    #   response.stream.write "#{i}hello world\n"
    #   sleep 1
    # end
  ensure
    Rails.logger.debug("done")
    response.stream.write("Done\n")
    response.stream.close
  end


  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    retval = ""
    repeat = REPEAT
    if params[:times].present?
      repeat = params[:times].to_i
    end
    repeat.times {
      @messages.each do |message|
        retval << message.as_json.to_s
        retval << "\n"
      end
    }
    retval << "Done\n"
    render :text => retval, :content_type => Mime::TEXT
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:content)
    end
end
