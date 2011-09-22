class Term < ActiveRecord::Base
  has_many :term_mappings
  has_many :documents, :through => :term_mappings
  has_and_belongs_to_many :preterms,
    :class_name => 'Term',
    :association_foreign_key => "preterm_id",
    :join_table => "preterms"
  has_and_belongs_to_many :postterms,
    :class_name => 'Term',
    :association_foreign_key => "postterm_id",
    :join_table => "postterms"


  # 
  def preterm_tree(level = 3)
    level = level.to_i
    return {:name => name} if level == 1
    p = preterms.select('id, name, COUNT(id) AS cnt').group(:id).order(:cnt)
    #return nil if p.size < 10 
    { :name => name, :children => p.map {|x| x.preterm_tree(level - 1)}}
  end

  def postterm_tree(level = 3, i = 1, order = 'cnt')
    level = level.to_i
    i = i.to_i
    return {:name => name} if level == i
    p = postterms.select('id, name, COUNT(id) AS cnt').group(:id).order(order)
    { :name => name, :children => p.map {|x| x.postterm_tree(level, i + 1)}}
  end
end
