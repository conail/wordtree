class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def create
    redirect_to action: :show, id: params[:term]
  end

  def show
    headers['Last-Modified'] = Time.now.httpdate

    #flr = params[:floor] 
    flr ||= 3
    limit = params[:limit].to_i

    # Create a stub so forms etc. function.
    @tree = Tree.new  

    # The source term
    src = params[:id]

    # Generate a document sentence set
    # Default is the set of all sentences
    $r.sunionstore('sset', *$r.keys('document:*'))
    sset = 'sset'

    # Tree to be returned asynchronously
    @json = []

    # Unless there is a set of proceeding terms that matches
    unless $r.exists "focus:#{sset}:#{src}" then
      $r.smembers("dst:#{src}").each do |dst|
        s = "edge:#{src}:#{dst}" 
  
        # Set weight to zero of interested set to 
        # prevent score distortion.
        $r.zinterstore('tmp', [s, sset], weight: [1, 0])
  
        # Return sentence-level frequencies 
        scores = $r.zrange('tmp', 0, 1, with_scores: true)
  
        # Find frequency by summing sentence-level frequencies.
        freq = 1.step(scores.size-1, 2).inject(0) do |sum, i| 
          sum += scores[i].to_i
        end

        $r.zincrby("focus:#{sset}:#{src}", freq-1, dst.unpack('C*').pack('U*'))
      end
    end

    $r.zrangebyscore("focus:#{sset}:#{src}", flr, '+inf', with_scores: true, limit: [0, limit]).each_slice(2) do |n, f|
      @json << {name: n, freq: f.to_i}
    end
  end
end
