class Diary < ApplicationRecord
  validates :comment, presence: true, length: { maximum: 65_535 }
  validates :location, presence: true, length: { maximum: 255 }
  validates :date, presence: true

  belongs_to :user
  belongs_to :plan, optional: true

  mount_uploader :image, DiaryImageUploader

  paginates_per 20

  def self.ransackable_attributes(auth_object = nil)
    [ "comment", "location", "date", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [] 
  end
end
