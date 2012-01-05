class Document
  include Mongoid::Document
  field :title
  field :content
  field :student_id
  field :code
  field :level 
  field :date 
  field :module
  field :dgroup 
  field :grade   
  field :words    
  field :sunits    
  field :punits     
  field :macrotype     
  field :xml  

  def sentences
    Nokogiri(xml).css('body s').map(&:text)
  end

  def self.clean(str)
    str.downcase.gsub(/[^a-z0-9 ]/, '').strip
  end
end
