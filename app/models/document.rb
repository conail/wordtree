class Document < ActiveRecord::Base
  has_many :sentences
  belongs_to :genre
  belongs_to :discipline

  validates :level, presence: true

  def self.clean(str)
    str.downcase.gsub(/[^a-z0-9 ]/, '').strip
  end
end
