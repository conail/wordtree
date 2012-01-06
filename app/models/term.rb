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
    @depth  = depth
    @occurs = occurs
    {
      name: @term, 
      keys: $r.scard("search:#{@term}"),
      children: descendants(@term)
    }
  end

  def descendants(parent, stack = [])
    return [] if stack.size >= @depth 
    o = 6 + parent.size
    a = []
    $r.keys("link:#{parent}:*")[0..@branching].each do |key| 
      new_stack = stack + [key]
      occurs = $r.send(:sinter, *new_stack)
      next if occurs.size < @occurs
      a << {
        name:     key[o..-1],
        keys:     occurs.size, 
        children: descendants(key[o..-1], new_stack), 
      }
    end
    a
  end
end
