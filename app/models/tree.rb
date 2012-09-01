class Tree
  attr_reader :root, :headword

  def initialize(node)
    @root = node
    @headword = node.name
  end 

  def self.add_tokens(tokens)
    return if tokens.size < 2

    headword = tokens.shift
    suffix = tokens.join(' ')
    
    if root = self.find_root(headword) then
      root.suffix = suffix
    else # Add new root
      root = Node.new(name: headword, suffix: suffix)
      $r.hset(:roots, root.name, root.id)
    end

    root
  end

  def self.root_words
    $r.hkeys(:roots)
  end

  def self.roots
    $r.hvals(:roots).map{|x| Node.new(id: x.to_i)}
  end

  def self.find_root(headword)
    root_id = $r.hget(:roots, headword)
    root_id ? Node.new(id: root_id) : nil
  end
end