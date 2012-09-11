# DATA STRUCTURE
# - roots     -> Hash [ id ]
# - node:id   -> Hash [ Depth, Terminal, Suffix, Parent ]
# - children  -> Set  [ node_id ]
# - documents -> Ordered Set [ document_id]

class Node
  attr_reader :id, :name, :suffix, :child_ids, :child_names

  def children; @child_ids.map{|x| Node.new(id: x)}; end
  def occurs; $r.hlen("children:#{@id}"); end

  def to_json
    h = {name: @name}
    children.empty? ?
      h[:suffix] = @suffix :
      h[:children] = children.map(&:to_json)  
    h
  end

  def add_child(options)
    if idx = @child_names.index(options[:name])
      existing_child = Node.new(id: @child_ids[idx])
      existing_child.suffix = options[:suffix]
    else # add new node
      new_child = Node.new(options)
      @child_ids   << new_child.id
      @child_names << new_child.name
      $r.hset("children:#{@id}", new_child.id, new_child.name)
    end
  end

  def add_document(document_id)
    $r.sadd("documents:#{@id}", document_id)
  end

  def suffix=(suffix)
    return nil unless suffix

    # Housekeeping: there can't be any suffix *and* children
    if @suffix then
      add_child(components(@suffix))
      @suffix = nil
      $r.hdel("node:#{@id}", :suffix)
    end

    if @child_ids.empty? then
      @suffix = suffix
      $r.hset("node:#{@id}", :suffix, suffix)
    else
      add_child(components(suffix))
    end
  end

  def initialize(options)
    @child_ids   = []
    @child_names = []
    @documents   = []

    if options[:id] then 
      read_node(options[:id])
    else
      set_node(options[:name], options[:suffix], options[:document_id])
    end

    self
  end

  def set_node(name, suffix, document)
    raise NodeIncompleteError if name.nil?

    @id = $r.incr(:node_total)

    @name = name
    $r.hset("node:#{@id}", :name, @name)

    if suffix then
      @suffix = suffix
      $r.hmset("node:#{@id}", :suffix, @suffix)
    end
  end

  def read_node(id)
    raise NodeNotFoundError unless $r.exists("node:#{id}")
    @id          = id
    @name        = $r.hget("node:#{@id}", :name)
    @suffix      = $r.hget("node:#{@id}", :suffix)
    @child_ids   = $r.hkeys("children:#{@id}").map(&:to_i)
    @child_names = $r.hvals("children:#{@id}")
  end

  def self.load_string(str)
    m = str.match(/(\w+) (.+$)/)
    Node.new({ name: m ? m[1] : str, suffix: m[2] })
  end
  
  # Finder methods 
  def self.all
    keys = $r.keys('node:*')
    return if keys.empty?

    keys.map do |x| 
      Node.new(id: x[5..-1])
    end
  end

  def self.first
    keys = $r.keys('node:*')
    return if keys.empty?
    Node.new(id: keys.first[5..-1])
  end

  def self.last
    keys = $r.keys('node:*')
    return if keys.empty?
    Node.new(id: keys.last[5..-1])
  end

  # Delete a single node.
  def delete
    collections = %w[node children documents]
    collections.each{|c| $r.del("#{c}:#{@id}")}
    true
  end
  
  # Delete all nodes.
  def self.delete_all
    %w[roots node_total].each{|x| $r.del(x)}
    %w[node children documents].each do |lbl|
      keys = $r.keys("#{lbl}:*")
      $r.del(*keys) unless keys.empty?
    end
    true
  end

private
  def components(str)
    Raise NoSuffixGiven unless str
    m = str.match(/(\w+) (.+$)/) 
    m.nil? ? {name: str} : {name: m[1], suffix: m[2]}
  end
end
