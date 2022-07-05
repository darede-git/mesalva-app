# frozen_string_literal: true

{
  index: 'get',
  create: 'post',
  show: 'get',
  update: 'put',
  destroy: 'delete'
}.each do |action, verb|
  RSpec.shared_examples "a generic #{action} route" do |controller|
    controller_name = controller.pluralize
    it "and route to #{controller_name}##{action}" do
      if has_param?(action)
        expect(verb => "/#{controller.pluralize}/1")
          .to route_to(controller.pluralize + "##{action}", id: '1')
      else
        expect(verb => "/#{controller_name}")
          .to route_to(controller_name + "##{action}")
      end
    end
  end
end

def has_param?(action)
  %i[show update destroy].include? action
end
