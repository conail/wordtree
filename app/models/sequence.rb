# NAME
#   Sequence
#
# SYNOPSIS
#   generate monotonically increasing but *pretty* ids in mongoid
#
# DESCRIPTION
#   following is a teeny bit of code which can be used to efficiently
#   generate batches of pretty integer type ids for your records
#
# USAGE
#
#   class A
#     include Mongoid::Document
#
#     field(:_id, default: proc{Sequence[A].next})
#     identity(:type => String)
#
#   # this is just to make find mo-betta, mongoid doesn't cast arguments to
#   # find - it is not required
#   #
#     def A.find(*args, &block)
#       args[0] = args[0].to_s if args.size == 1
#       super
#     end
#   end
#
#   p Array.new(3){ A.create.id }           #=> [1,2,3]
#   p [1,2,3].map{|id| A.find(id).id}       #=> ["1","2","3"]
#   p ["1","2","3"].map{|id| A.find(id).id} #=> ["1","2","3"]

class Sequence
  include Mongoid::Document
  field :name
  field :current, default: 1
  field :step, default: 10

  validates_presence_of :name
  validates_uniqueness_of :name
  index :name, unique: true

  Cache = Map.new

  class << Sequence
    def for(name)
      name = name.to_s

      Cache[name] ||= (
        begin
          create! name: name
        rescue
          where(name: name).first or create!(name: name)
        end
      )
    end

    alias_method('[]', 'for')
  end

  def next
    generate_next_values! if @value.nil? or @value == @last_value
    @value
    ensure
    @value += 1
  end

  def generate_next_values!
    @last_value = inc(:current, step)
    @value = @last_value - step
  end

  def reset!
    update_attributes!(current: 1)
    ensure
    @value = @last_value = nil
  end
end
