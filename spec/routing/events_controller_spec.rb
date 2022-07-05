# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::PermalinkController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/events/permalink/example')
        .to route_to('event/permalink#show', slug: 'example')

      expect(get: '/events/permalink/example?group_by=node')
        .to route_to(
          'event/permalink#show',
          slug: 'example',
          group_by: 'node'
        )

      expect(get: '/events/permalink/example?expanded=true')
        .to route_to(
          'event/permalink#show', slug: 'example', expanded: 'true'
        )

      expect(get: '/events/permalink/example?expanded=true&group_by=node')
        .to route_to('event/permalink#show', slug: 'example',
                                             expanded: 'true',
                                             group_by: 'node')

      expect(get: '/events/user/last_modules')
        .to route_to('event/user/last_modules#show')

      expect(get: '/events/user/last_modules?page=1')
        .to route_to('event/user/last_modules#show', page: '1')

      expect(get: '/events/user/last_modules?education_segment=engenharia')
        .to route_to(
          'event/user/last_modules#show',
          education_segment: 'engenharia'
        )
      expect(
        get: '/events/user/last_modules?page=2&education_segment=engenharia'
      ).to route_to(
        'event/user/last_modules#show',
        education_segment: 'engenharia',
        page: '2'
      )

      expect(post: '/events/permalink/example')
        .to route_to('events#create', slug: 'example')
    end
  end
end
