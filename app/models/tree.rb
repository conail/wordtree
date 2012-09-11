require 'benchmark'

class Tree
  attr_reader :root, :headword

  def initialize(name)
    @root = Tree.find_root(name)
    @headword = name
  end 

  def print
    q = [@root]
    until q.empty?
      node = q.pop 
      puts node.name
      q += node.children
    end
  end

  def to_json; @root.to_json; end

  def self.add_tokens(tokens, document_id)
    # why?
    return if tokens.size < 2

    # The headword to exist in the root catalog.
    headword = tokens.shift


    suffix = tokens.join(' ')
  
    # Maintain the root catalog.  Every root should only exist once.
    if root = self.find_root(headword) then
      # Add remainder of string (the suffix) to the existing root.
      root.suffix = suffix
      root.add_document(document_id)
    else 
      # Add new root
      root = Node.new(name: headword, suffix: suffix, document_id: document_id)
      # The root is typically search by literal name, but we also store 
      # the id.  Why?
      $r.hset(:roots, root.name, root.id)
    end

    root
  end


  # Return an array of all the headwords in the root catalog.
  def self.root_words
    $r.hkeys(:roots)
  end

  # Return an array of all the nodes in the root catalog.
  def self.roots
    $r.hvals(:roots).map do |x| 
      Node.new(id: x.to_i)
    end
  end

  # Returns the root node of a tree, given a headword.
  def self.find_root(headword)
    id = $r.hget(:roots, headword)
    id.nil? ? nil : Node.new(id: id)
  end

  # First attempt at timing tree generation.  Table output does not 
  # have headers.
  def self.test
    time = Benchmark.measure do
      (1..3).each { |i| Tree.new('of').to_json }
    end
    puts time
  end
end
