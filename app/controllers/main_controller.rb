class MainController < ApplicationController
  include ActionController::Live
  respond_to :json, only: [:repaired]

  def index

      @books = Book.all

      render stream: true
  end

  def create
    unless (params[:datafile].nil?)
    uploaded_io = params[:datafile]

    file = Rails.root.join('public', 'data', uploaded_io.original_filename)
    File.open(file, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    PdfParserWorker.perform_async("public/data/#{uploaded_io.original_filename}")
    else
      logger.info "нету файла"
    end
  end
  def show
      @individuals = Individual.where(book_id: params[:book_id])
      @groups = Group.where(book_id: params[:book_id])
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
