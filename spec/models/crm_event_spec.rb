# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrmEvent, type: :model do
  let(:crm_event_with_utm) do
    FactoryBot.attributes_for(:crm_event,
                              :with_utm_attributes)
  end

  let(:crm_event_with_utm_blank) do
    FactoryBot.attributes_for(:crm_event,
                              :with_utm_attributes_blank)
  end

  context '#utm_attributes' do
    context 'with utm attributes' do
      it 'creates a new crm event with utm' do
        expect do
          CrmEvent.create(crm_event_with_utm)
        end.to change(CrmEvent, :count).by(1)
                                       .and change(Utm, :count).by(1)
      end
    end

    context 'with utm source blank' do
      it 'creates a new crm event utm' do
        expect do
          CrmEvent.create(crm_event_with_utm_blank)
        end.to change(CrmEvent, :count).by(1)
                                       .and change(Utm, :count).by(0)
      end
    end
  end
end
