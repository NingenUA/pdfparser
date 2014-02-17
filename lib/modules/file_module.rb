module FileModule
  def save_file(input_file)
    uploaded_io = input_file
    file = Rails.root.join('public', 'data', uploaded_io.original_filename)
    File.open(file, 'wb') do |file|
      file.write(uploaded_io.read)
      uploaded_io.original_filename
    end
  end
end