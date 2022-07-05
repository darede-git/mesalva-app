# frozen_string_literal: true

# base_mudar => [ID_node_module, relevancy_novo, position_novo]

errors = []

base_mudar = [[811, 2, 6], [825, 2, 7], [6908, 15, 1_000_000], [7184, 15, 1_000_000]]

base_mudar.each do |nm|
  node = NodeModule.find(nm[0]).update(relevancy: nm[1], position: nm[2])
  node.relevancy << nm[1]
  node.position << nm[2]
  errors << nm unless node.save
end

puts errors.inspect
