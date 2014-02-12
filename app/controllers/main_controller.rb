class MainController < ApplicationController
  include ActionController::Live
  respond_to :json, only: [:repaired]

  def index

      @books = Book.all

      render stream: true
  end
  
  def save_file(input_file)
    uploaded_io = input_file
    file = Rails.root.join('public', 'data', uploaded_io.original_filename)
    File.open(file, 'wb') do |file|
      file.write(uploaded_io.read)
      uploaded_io.original_filename
    end
  end

  def create
    PdfParserWorker.perform_async("public/data/#{save_file(params[:datafile])}")
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
