class DiaryImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  storage :file if Rails.env.test?

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
