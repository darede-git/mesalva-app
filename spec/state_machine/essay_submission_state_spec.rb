# frozen_string_literal: true

require 'rails_helper'
RSpec.describe EssaySubmissionState, type: :model do
  let(:status) do
    { pending: 0,
      awaiting_correction: 1,
      correcting: 2,
      corrected: 3,
      delivered: 4,
      cancelled: 5,
      uncorrectable: 6,
      re_correcting: 7,
      re_corrected: 8 }
  end

  context 'after_transition' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let(:essay_submission) { create(:essay_submission_with_essay, user: user) }

    context 'creates and updates essay status' do
      before { essay_submission.state_machine.transition_to!(:correcting) }

      it 'should creates a new essay event' do
        expect(essay_submission.status).to eq(status[:correcting])
      end
    end
  end

  context 'after_transition to awaiting_correction' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let!(:essay_submission) { create(:essay_submission_with_essay, user: user) }
    before do
      essay_submission.state_machine.transition_to(:correcting)
    end

    context 'with grades' do
      before do
        essay_submission.update(grades: { "grade_1" => "550",
                                          "grade_final" => "550" })
        essay_submission.state_machine.transition_to(:corrected)
      end

      it 'should reset essay submission attributes' do
        expect do
          essay_submission.state_machine.transition_to!(:awaiting_correction)
        end.to change { essay_submission.reload.grades }
          .from("grade_1" => "550", "grade_final" => "550").to(nil)
      end
    end

    context 'with send date' do
      before do
        essay_submission.update(send_date: Date.yesterday)
        essay_submission.state_machine.transition_to(:corrected)
      end
      it 'should not update the send date if one is already present' do
        essay_submission.state_machine.transition_to!(:awaiting_correction)
        expect(essay_submission.reload.send_date).to eq(Date.yesterday)
      end
    end
  end

  context 'after_transition to corrected' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let(:essay_submission) { create(:essay_submission_with_essay, user: user) }
    let(:deliveries) { EssaySubmissionMailer.deliveries }
    delivered_message = I18n.t('mailer.essay_submission.delivered.subject')
    before do
      essay_submission.state_machine.transition_to(:correcting)
      essay_submission.state_machine.transition_to(:corrected)
    end

    it 'should send mail with right subject' do
      expect { essay_submission.state_machine.transition_to(:delivered) }
        .to change(deliveries, :count).by(1)
      expect(deliveries.last.subject).to eq(delivered_message)
    end
  end

  context 'after_transition to re_corrected' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let(:essay_submission) { create(:essay_submission_with_essay, user: user) }
    let(:deliveries) { EssaySubmissionMailer.deliveries }
    re_corrected_message = t('mailer.essay_submission.re_corrected.subject')
    before do
      essay_submission.state_machine.transition_to(:correcting)
      essay_submission.state_machine.transition_to(:corrected)
      essay_submission.state_machine.transition_to(:delivered)
      essay_submission.state_machine.transition_to(:re_correcting)
    end
    it 'should send mail with re-corrected subject' do
      expect { essay_submission.state_machine.transition_to(:re_corrected) }
        .to change(deliveries, :count).by(1)
      expect(deliveries.last.subject).to eq(re_corrected_message)
    end
  end

  context 'after_transition to uncorrectable' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let(:essay_submission) { create(:essay_submission_with_essay, user_id: user.id) }
    let(:deliveries) { EssaySubmissionMailer.deliveries }
    delivered_message = I18n.t('mailer.essay_submission.uncorrectable.subject',
                               platform: 'Me Salva!')
    before do
      essay_submission.state_machine.transition_to(:correcting)
    end

    it 'should send mail with right subject' do
      essay_submission.uncorrectable_message = 'some: message'
      expect { essay_submission.state_machine.transition_to(:uncorrectable) }
        .to change(deliveries, :count).by(1).and change { access.reload.essay_credits }
        .from(9).to(10)
      expect(deliveries.last.subject).to eq(delivered_message)
    end

    it 'refunds an essay credit' do
      essay_submission.uncorrectable_message = 'some: message'
      expect { essay_submission.state_machine.transition_to(:uncorrectable) }
        .to change { access.reload.essay_credits }.from(9).to(10)
    end
  end

  context 'after_transition to canceled' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let!(:essay_submission) { create(:essay_submission_with_essay, user_id: user.id) }

    it 'refunds an essay credit' do
      expect { essay_submission.state_machine.transition_to(:cancelled) }
        .to change { access.reload.essay_credits }.from(9).to(10)
    end
  end
end
