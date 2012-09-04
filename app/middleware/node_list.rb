require 'json'

class NodeList
  def initialize(app)
    @app = app
  end
  
  def call(env)
    m = env["PATH_INFO"].match(/\/n\/(\d+)/)
    if ! m.nil?
      [200, {'Content-Type' => 'text/json'},
        JSON.generate(Node.new(id: m[1]).children.map do |node|
          h = {id: node.id, name: node.name}
          node.suffix ?
            h[:suffix] = node.suffix :
            h[:occurs] = node.occurs
          h
        end)
      ]
    else
      @app.call(env)
    end
  end
end