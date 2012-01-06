class Document < ActiveRecord::Base
  has_many :sentences

  def self.clean(str)
    str.downcase.gsub(/[^a-z0-9 ]/, '').strip
  end
end
