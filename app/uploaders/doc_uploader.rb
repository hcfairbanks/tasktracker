class DocUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    File.join(Rails.root,"dynamic_files",Rails.env,"#{model.class.to_s.underscore}", "#{mounted_as}", model.id.to_s) # This worked
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end


  def is_image?
    [".png", ".JPEG",".JPG",".jpeg",".jpg",".gif"].include? File.extname(model.doc_identifier)
  end

  def thumb_path
    if is_image?
      File.join(store_dir,"thumb_#{model.doc_identifier}")
    else
      File.join(Rails.root,"app","assets","images","doc_thumb.jpg")
    end
  end

  def doc_path
    File.join(store_dir, model.doc_identifier)
  end

  def thumb_url
    File.join(base_url,"serve_thumb")
  end

  def doc_url
    File.join(base_url,"serve_doc")
  end

  def base_url
    File.join(ENV['ROOT_URL'], model.id.to_s )
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  version :thumb, :if => :image? do
    process resize_to_fill: [50,50]
    #process resize_to_fill: [200,200]
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

  def image?(new_file)
    new_file.content_type.include? 'image'
  end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
