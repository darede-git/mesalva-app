# frozen_string_literal: true

RSpec.shared_context "permalink building" do
  let(:node1) { create(:node) }
  let(:node2) { create(:node_area, parent_id: node1.id) }
  let(:node3) { create(:node_subject, parent_id: node2.id) }
  let(:node_module) { create(:node_module, nodes: [node3]) }
  let(:item) { create(:item, node_modules: [node_module]) }
  let(:item2) { create(:item, node_modules: [node_module]) }
  let(:medium) { create(:medium, items: [item]) }

  let!(:complete_permalink) do
    create(
      :permalink,
      slug: "#{node1.slug}/#{node2.slug}/#{node3.slug}/"\
            "#{node_module.slug}/#{item.slug}/#{medium.slug}",
      nodes: [node1, node2, node3],
      node_module: node_module,
      item: item,
      medium: medium
    )
  end

  let(:item_permalink) do
    create(
      :permalink,
      slug: "#{node1.slug}/#{node2.slug}/#{node3.slug}/"\
            "#{node_module.slug}/#{item.slug}",
      nodes: [node1, node2, node3],
      node_module: node_module,
      item: item
    )
  end

  def mock_user_consumed_modules_cache(data)
    mock_user_cache('consumed_modules', data)
  end

  def mock_user_consumed_media_cache(data)
    mock_user_cache('consumed_media', data)
  end

  def mock_user_cache(cache, data)
    allow(Redis.current).to receive(:get)
      .with("#{cache}.#{user.id}")
      .and_return(data.to_json)
  end
end
