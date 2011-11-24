class Term < Neo4j::Model
  property :name, :type => String

  has_n :documents
  has_n :follows

  index :name

  def tree(d = 5)
    d = d.to_i
    h = {:name => self[:name]}
    if d == 1 then
      h
    else
      h.merge!({:children => outgoing(:follows).map{|x| x.tree(d-1)}})
    end
  end

  # phrases
  # font-sizes
  # display entire sentence
end
