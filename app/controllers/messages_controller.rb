class MessagesController < ApplicationController
  include ActionController::Live
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  REPEAT = 1

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    @streaming = params[:stream] == "true" ? true : false
    @with_js = params[:with_js] == "true" ? true : false

    respond_to do |format|
      format.html {}
      format.json { render action: 'check' }
    end
  end

  def check
    @messages = Message.all
    retval = ""

    @repeat ||= params[:times].present? ? params[:times].to_i : REPEAT
    @streaming ||= params[:stream].present? ? params[:stream] == "true" : false

    response.headers['Content-Type'] = 'text/event-stream' if @streaming

    @repeat.times {
      if @streaming
        @messages.find_each do |message|
          response.stream.write "data: #{message.to_json}\n\n"
        end
      else
        retval = @messages.to_json
      end
    }
  ensure
    if @streaming
      # puts "\nDone Streaming\n"
      response.stream.close
    else
      render :json => retval
    end
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
