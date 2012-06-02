class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def show
    headers['Last-Modified'] = Time.now.httpdate

    @tree = Tree.new  

    src = params[:id]
    # $r.sunionstore('sset', *$r.keys('document:*'))
    sset = 'sset'

    @json = []
    unless $r.exists "focus:#{sset}:#{src}" then
      $r.smembers("dst:#{src}").each do |dst|
        s = "edge:#{src}:#{dst}" 
  
        # Set weight to zero of interested set to prevent score distortion.
        $r.zinterstore('tmp', [s, sset], weight: [1, 0])
  
        # Return sentence-level frequencies -- quite a lot of wasted computation here.
        scores = $r.zrange('tmp', 0, 1, with_scores: true)
  
        # Find frequency by summing sentence-level frequencies.
        freq = 1.step(scores.size-1, 2).inject(0){|sum, i| sum += scores[i].to_i}

        $r.zincrby("focus:#{sset}:#{src}", freq-1, dst.unpack('C*').pack('U*'))
      end
    end
    $r.zrangebyscore("focus:#{sset}:#{src}", 9, '+inf', with_scores: true).each_slice(2) do |n, f|
      @json << {name: n, freq: f.to_i}
    end
  end
end
