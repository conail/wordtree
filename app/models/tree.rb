require "benchmark"

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

  def to_json
    @root.to_json
  end

  def self.test
    time = Benchmark.measure do
      (1..3).each { |i| Tree.new('of').to_json }
    end
    puts time
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