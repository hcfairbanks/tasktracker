class AvatarUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w(jpg jpeg png gif)
  end

  include CarrierWave::RMagick
  storage :file

  def store_dir
    File.join(Rails.root,"dynamic_files",Rails.env,"#{model.class.to_s.underscore}", "#{mounted_as}", model.id.to_s) # This worked
  end

  def is_image?
    [".png", ".JPEG",".JPG",".jpeg",".jpg",".gif"].include? File.extname(model.avatar_identifier)#.downcase
  end

  def small_path
      File.join(store_dir,"small_#{model.avatar_identifier}")
  end

  def medium_path
      File.join(store_dir,"medium_#{model.avatar_identifier}")
  end

  def large_path
      File.join(store_dir,"#{model.avatar_identifier}")
  end

  def small_url
    File.join(base_url,"serve_small")
  end

  def medium_url
    File.join(base_url,"serve_medium")
  end

  def large_url
    File.join(base_url,"serve_medium")
  end

  def base_url
    File.join(ENV['ROOT_URL'],"#{model.class.to_s.downcase}s", model.id.to_s )
  end

  version :small do
    process resize_to_fill: [50, 50]
  end
  version :medium do
    process resize_to_fill: [100, 100]
  end
  version :large do
    process resize_to_fill:  [200, 200]
  end

end
