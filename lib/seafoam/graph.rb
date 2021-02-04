module Seafoam
  # A graph, with properties, nodes, and edges. We don't encapsulate the graph
  # too much - be careful.
  class Graph
    attr_reader :props, :nodes, :edges

    def initialize(props = nil)
      @props = props || {}
      @nodes = {}
      @next_id = 0
      @edges = []
    end

    # Create a node.
    def create_node(id = nil, props = nil)
      id ||= @next_id
      props ||= {}
      node = Node.new(id, props)
      @nodes[id] = node
      @next_id = [@next_id, id + 1].max
      node
    end

    # Create an edge between two nodes.
    def create_edge(from, to, props = nil)
      props ||= {}
      edge = Edge.new(from, to, props)
      @edges.push edge
      from.outputs.push edge
      to.inputs.push edge
      edge
    end
  end

  # A node, with properties, input edges, and output edges.
  class Node
    attr_reader :id, :inputs, :outputs, :props

    def initialize(id, props = nil)
      props ||= {}
      @id = id
      @inputs = []
      @outputs = []
      @props = props
    end

    # All edges - input and output.
    def edges
      inputs + outputs
    end

    # All adjacent nodes - from input and output edges.
    def adjacent
      (inputs.map(&:from) + outputs.map(&:to)).uniq
    end

    # id (label)
    def id_and_label
      if props[:label]
        "#{id} (#{props[:label]})"
      else
        id.to_s
      end
    end

    # Inspect.
    def inspect
      "<Node #{id}>"
    end
  end

  # A directed edge, with a node it's from and a node it's going to, and
  # properties.
  class Edge
    attr_reader :from, :to, :props

    def initialize(from, to, props = nil)
      props ||= {}
      @from = from
      @to = to
      @props = props
    end

    # Both nodes - from and to.
    def nodes
      [@from, @to]
    end

    # Inspect.
    def inspect
      "<Edge #{from.id} -> #{to.id}>"
    end
  end
end
