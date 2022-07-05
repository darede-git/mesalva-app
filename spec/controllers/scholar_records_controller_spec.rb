# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarRecordsController, type: :controller do
  describe 'GET index' do
    it_behaves_like 'a unauthorized index route for', %w[admin guest]

    context 'with a valid session' do
      before { user_session }

      context 'user with scholar records' do
        let!(:scholar_record) do
          create(:scholar_record, :with_school, user: user)
        end
        let!(:scholar_record_inactive) do
          create(:scholar_record, :with_school, :inactive, user: user)
        end
        let!(:invalid_user) { create(:scholar_record, :with_school) }

        it 'returns only the active scholar records by user' do
          get :index

          assert_jsonapi_response(:ok,
                                  [scholar_record],
                                  ScholarRecordSerializer)
        end
      end
    end
  end

  describe 'POST create' do
    it_behaves_like 'a unauthorized create route for', %w[admin guest]

    context 'with a valid session' do
      before { user_session }

      context 'with valid params' do
        let(:valid_attributes) do
          attributes_for(:scholar_record, school_id: create(:school).id)
        end

        context 'without a last scholar record' do
          it 'creates a new scholar record and returns it' do
            expect do
              post :create, params: valid_attributes
            end.to change(ScholarRecord, :count).by(1)

            expect(ScholarRecord.last.active).to eq(true)
            assert_jsonapi_response(:created,
                                    ScholarRecord.last,
                                    ScholarRecordSerializer)
          end
        end

        context 'with a last scholar record active' do
          let!(:last_scholar_record) do
            create(:scholar_record, :with_college, user: user)
          end

          it 'creates a new scholar record and disable the last' do
            expect do
              post :create, params: valid_attributes
            end.to change(ScholarRecord, :count).by(1)

            expect(ScholarRecord.last.active).to eq(true)
            expect(last_scholar_record.reload.active).to eq(false)
            assert_jsonapi_response(:created,
                                    ScholarRecord.last,
                                    ScholarRecordSerializer)
          end
        end
      end

      context 'with invalid params' do
        let(:invalid_attributes) do
          attributes_for(:scholar_record, education_level: nil)
        end

        it 'returns unprocessable_entity' do
          post :create, params: invalid_attributes

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET disable' do
    before { user_session }

    context 'with a last scholar record active' do
      let!(:last_scholar_record) do
        create(:scholar_record, :with_school, user: user)
      end
      it 'disables the last' do
        expect(last_scholar_record.active).to eq(true)
        get :disable
        expect(last_scholar_record.reload.active).to eq(false)
        assert_jsonapi_response(:ok,
                                last_scholar_record,
                                ScholarRecordSerializer)
      end
    end
    context 'without a last scholar record' do
      it 'returns not found' do
        get :disable
        assert_type_and_status(:not_found)
      end
    end
  end
end
