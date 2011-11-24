class Genre < Neo4j::Model 
  has_n :documents

  index :name

  validates_uniqueness_of :name
end
