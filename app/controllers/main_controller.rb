class MainController < ApplicationController
  include ActionController::Live
  include FileModule
  respond_to :json, only: [:repaired]

  def index
    @books = Book.order("created_at DESC").page(params[:page])
    render stream: true
  end


  def create
    PdfParserWorker.perform_async("public/data/#{save_file(params[:datafile])}")
  end

  def show
    @individuals = Individual.where(book_id: params[:book_id])
    @groups = Group.where(book_id: params[:book_id]).page(params[:page])
    render stream: true
  end

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new
    redis.subscribe('book_created') do |on|
      on.message do |event, data|
        response.stream.write("event: bookcreated\n")
        response.stream.write "data: #{data}\n\n"
      end
    end
    render nothing: true
  rescue IOError
    logger.info "Stream closed"
  ensure
    response.stream.close
  end





end