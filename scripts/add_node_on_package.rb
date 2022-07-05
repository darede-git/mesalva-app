# frozen_string_literal: true

pacotes = [2781, 2761, 2938, 2936, 2937, 2935, 2928]

nodes = [1025, 1058, 1087, 1111, 1155, 1176, 1188, 1222, 1250, 1262, 1277, 1294, 1350, 1352]

pacotes.each do |pacote|
  nodes.each do |node|
    ins_node = Node.find(node)
    ins_pacote = Package.find(pacote)
    ins_pacote.nodes << ins_node
    errors << [pacote, node] unless ins_pacote.save
  end
end

puts erros.inspect
