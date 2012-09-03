class NodeList
  def initialize(app)
    @app = app
  end
  
  def call(env)
    m = env["PATH_INFO"].match(/\/n\/(\d+)/)
    if ! m.nil?
      [200, {'Content-Type' => 'text/json'},
       "[" + Node.new(id: m[1]).children.map do |node|
        str = '{"id": ' + node.id.to_s 
        str += ', "name": "' + node.name + '", '
        str += node.suffix ?
          '"suffix": "' + node.suffix + '"}' :
          '"occurs": ' + node.occurs.to_s + '}'
        str
      end.join(",\n ") + ']']
    else
      @app.call(env)
    end
  end
end