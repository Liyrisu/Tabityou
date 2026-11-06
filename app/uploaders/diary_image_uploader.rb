class DiaryImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def extension_allowlist
    %w[jpg jpeg gif png]
  end
end
