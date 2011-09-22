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

  def preterm_tree(level = 3)
    level = level.to_i
    return {:name => name} if level == 1
    { :name => name, :children => preterms.select('id, name, COUNT(id) AS cnt').group(:id).map {|x| x.preterm_tree(level - 1)}}
  end

  def postterm_tree(level = 3, i = 1)
    level = level.to_i
    i = i.to_i
    return {:name => name} if level == i
    { :name => name, :children => postterms.select('id, name, COUNT(id) AS cnt').group(:id).map {|x| x.postterm_tree(level, i + 1)}}
  end
end
