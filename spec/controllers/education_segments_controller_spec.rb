# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationSegmentsController, type: :controller do
  include ContentStructureCreationHelper

  before :all do
    Node.destroy_all
    create_platform_node
    @education_segment = create(:node, parent_id: 1, id: 2)
  end

  after :all do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  describe 'GET #index' do
    it 'returns http success with session' do
      authentication_headers_for(user)
      get :index

      assert_jsonapi_response(:ok, [@education_segment],
                              EducationSegmentSerializer)
    end

    it 'returns http success' do
      get :index

      assert_jsonapi_response(:ok, [@education_segment],
                              EducationSegmentSerializer)
    end
  end

  describe 'GET #get_area_subjects' do
    let!(:node_area) do
      create(:node_area, parent_id: @education_segment.id, id: 3)
    end
    let!(:node_area_subject) do
      create(:node_area_subject, parent_id: node_area.id,
                                 id: 4, name: 'B')
    end
    let!(:node_area_subject2) do
      create(:node_area_subject, parent_id: node_area.id,
                                 id: 5, name: 'A')
    end

    context '#response' do
      context 'with a valid education_segment_slug' do
        it 'returns area_subject that belongs to an education_segment' do
          get :area_subjects, params: {
            education_segment_slug: @education_segment.slug
          }
          assert_jsonapi_response(:ok, [node_area_subject2, node_area_subject],
                                  EducationSegment::AreaSubjectSerializer)
          expect(parsed_response['data'].first['attributes'].keys).to \
            eq %w[slug name image]
          expect(parsed_response['data'].first['id']).to \
            eq node_area_subject2.id.to_s
        end
      end

      context 'with an invalid education_segment_slug' do
        it 'returns http status not found' do
          get :area_subjects, params: { education_segment_slug: node_area.slug }

          assert_type_and_status(:not_found)
        end
      end
    end

    context '#order' do
      it 'returns area_subject ordered by name' do
        get :area_subjects, params: {
          education_segment_slug: @education_segment.slug
        }

        expect(response.body)
          .to eq(to_jsonapi([node_area_subject2, node_area_subject],
                            EducationSegment::AreaSubjectSerializer))
      end
    end
  end
end
