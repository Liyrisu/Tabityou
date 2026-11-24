class DiaryImageUploader < CarrierWave::Uploader::Base
  if Rails.env.test?
    storage :file
  else
    include Cloudinary::CarrierWave
  end

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
