# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment::MediaController, type: :routing do
  describe 'routing' do
    describe '#create' do
      context 'slug has slashes' do
        it 'routes correctly' do
          expect(post: '/media/matematica/geometria/comments')
            .to route_to('comment/media#create',
                         permalink_slug: 'matematica/geometria')
        end
      end

      context 'slug does not have slashes' do
        it 'routes correctly' do
          expect(post: '/media/matematica/comments')
            .to route_to('comment/media#create',
                         permalink_slug: 'matematica')
        end
      end
    end

    describe '#update' do
      context 'has token and slug has slashes' do
        it 'routes to #update' do
          expect(put: '/media/matematica/geometria/comments/abc')
            .to route_to('comment/media#update',
                         permalink_slug: 'matematica/geometria',
                         token: 'abc')
        end
      end

      context 'has token and slug does not have slashes' do
        it 'routes to #update' do
          expect(put: '/media/matematica/comments/abc')
            .to route_to('comment/media#update',
                         permalink_slug: 'matematica',
                         token: 'abc')
        end
      end
    end

    describe '#index' do
      it 'routes to #index' do
        expect(get: '/media/matematica/geometria/comments')
          .to route_to('comment/media#index',
                       permalink_slug: 'matematica/geometria')
      end
    end
  end
end
