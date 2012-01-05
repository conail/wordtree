class Term
  $r = Redis.new
  PREFIX = 'link'

  attr_accessor :keys

  def initialize(term)
    @term       = term
    @keys       = $r.keys "#{PREFIX}:#{@term}:*"
  end

  def tree(depth = 3, branching = 20, occurs = 100)
    @branching = branching
    @occurs = occurs
    {
      name: @term, 
      keys: $r.scard("search:#{@term}"),
      children: descendants(@term, depth)
    }
  end

  def descendants(parent, depth)
    return [] if depth <= 1
    o = 6 + parent.size
    a = []
    $r.keys("link:#{parent}:*")[0..@branching].each do |key| 
      child = key[o..-1]
      occurs = $r.sinter "search:#{@term}", "search:#{parent}"
      next if occurs.size < @occurs
      a << {name: child, keys: occurs.size, children: descendants(child, depth - 1) }
    end
    a
  end
end
