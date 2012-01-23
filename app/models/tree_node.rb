class TreeNode
  attr_accessor :term, :children, :parent

  def initialize(term)
    @term = term
    @children = []
    @parent = nil
  end
  
  def clear!
    @children = []
  end

  def to_s
    pt = @parent.term unless @parent.nil?
    ch = @children.size
    "<Node term:'#{@term}' parent:'#{pt}' children:#{ch}>"
  end

  def root
    n = self
    n = n.parent while not n.parent.nil?
    n
  end

  def child_terms
    @children.map(&:term)
  end 

  def <<(node)
    idx = child_terms.index(node.term)
    if idx.nil? then
      @children << node
      node.parent = self
    else
      n = @children[idx]
      node.children.each{|x| n << x}
    end
    n || node
  end

  def breadth
    q = [self]
    while (n = q.pop) != nil
      yield n
      n.children.each{|x| q << x}
    end
  end

  def depth(&block) 
    yield self
    @children.each{|n| n.depth(&block)}
    puts '---'
  end

  def json
    str = "{\"keys\": 45, \"name\": \"#{self.term}\""
    unless @children.empty?
      str += ", \"children\": [#{@children.map(&:json).join(', ')}]"
    end
    str + '}'
  end

  def count
    @children.inject(1){|sum, n| sum += n.count}
  end

  def collapse
    a = []
    n = self
    begin
      return false if n.children.size != 1
      a << n.term
      n = n.children.first
    end while not n.children.empty?
    a << n.term
    @term = a.join(' ')
    @children = []
  end
end
