# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EssaySubmission, type: :model do
  context 'validations' do
    should_be_present(:permalink, :user, :correction_style)
    should_have_many(:essay_submission_transitions, :essay_events, :comments)
    it { should have_many(:essay_marks).order(id: :asc) }
    it { should accept_nested_attributes_for(:essay_marks).allow_destroy(true) }

    it do
      should validate_inclusion_of(:correction_type).in_array(
        %w[redacao-padrao redacao-personalizada redacao-b2b]
      )
    end

    context "when update status to uncorrectable without message" do
      let(:essay_submission) { create(:essay_submission) }
      it 'should raise error' do
        expect(essay_submission.update(status: described_class::STATUS[:uncorrectable])).to eq(false)

        error_prefix = 'activerecord.errors.models.essay_submission'
        error_sufix = 'attributes.uncorrectable_message.validate_uncorrectable_message_presence'
        error_message = t("#{error_prefix}.#{error_sufix}")
        expect(essay_submission.errors.messages).to eq(uncorrectable_message: [error_message])
      end
    end
  end

  context 'before / after save' do
    let(:essay_submission) { create(:essay_submission) }
    let!(:access) { create(:access_with_duration_and_node, user: essay_submission.user) }

    context 'with essay' do
      before do
        essay_submission.essay = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUg'\
        'AAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJ'\
        'ggg=='
      end

      context 'when status is pending and user has credits' do
        it 'transits to awaiting correction and substract one essay credit' do
          expect do
            essay_submission.save
          end.to change { essay_submission.status }
            .from(0).to(1)
            .and change { access.reload.essay_credits }
            .from(10).to(9)
        end
      end

      context 'when status is pending' do
        before { essay_submission.status = 3 }

        it 'not transits to awaiting correction' do
          expect do
            essay_submission.save
          end.not_to change(essay_submission, :status)
        end
      end

      context 'when user havent credits but try to send essay' do
        before do
          access.update(essay_credits: 0)
          essay_submission.essay = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUg'\
            'AAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg=='
        end
        it 'does not save changes' do
          expect do
            essay_submission.save
          end.not_to change(essay_submission, :status)
        end
      end
    end
  end

  let!(:active_essay) { create(:essay_submission) }
  let!(:user) { create(:user) }

  context 'scopes' do
    describe '.active' do
      it 'returns only the active essay submissions' do
        create(:essay_submission, active: false)

        expect(EssaySubmission.active).to eq([active_essay])
      end
    end

    describe '.by_user' do
      it 'return user essay submissions' do
        user_essay = create(:essay_submission, user_id: user.id)

        expect(EssaySubmission.by_user(user)).to eq([user_essay])
      end
    end

    describe '.by_user_active' do
      let!(:first_essay) do
        create(:essay_submission, user_id: user.id)
      end
      let!(:second_essay) do
        create(:essay_submission, user_id: user.id)
      end
      let!(:inactive_essay) do
        create(:essay_submission, user_id: user.id, active: false)
      end

      it 'return only the user essay submissions actived' do
        expect(EssaySubmission.by_user_active(user, 'asc'))
          .to eq([first_essay, second_essay])
      end

      it 'return essays ordered by created_at param' do
        expect(EssaySubmission.by_user_active(user, 'asc').first)
          .to eq(first_essay)
        expect(EssaySubmission.by_user_active(user, 'desc').first)
          .to eq(second_essay)
      end
    end

    describe '.by_correction_style' do
      let(:correction_style) { create(:correction_style) }
      let(:essay) do
        create(:essay_submission, correction_style: correction_style)
      end

      it 'return essay submissions by correcton style' do
        expect(EssaySubmission.by_correction_style(correction_style.id))
          .to eq([essay])
      end
    end

    describe '.by_status' do
      let!(:access) { create(:access_with_duration_and_node, user: user) }
      let!(:essay) { create(:essay_submission_with_essay, user: user) }
      before { essay.state_machine.transition_to(:correcting) }

      it 'return essay submissions by status' do
        expect(EssaySubmission.by_status('correcting')).to eq([essay.reload])
      end
    end

    describe '.expired_correcting' do
      let!(:access) { create(:access_with_duration_and_node, user: user) }
      let!(:expired_correcting_essay) do
        create(:essay_submission_with_essay,
               :correcting, user: user,
                            updated_at: Time.now - 122.minutes)
      end
      let!(:correcting_essay) do
        create(:essay_submission_with_essay, :correcting, user: user)
      end
      let!(:awaiting_correction_essay) { create(:essay_submission_with_essay, user: user) }

      it 'return expired correcting essay' do
        expect(EssaySubmission.expired_correcting)
          .to eq([expired_correcting_essay])
      end
    end

    describe '.current_week_by_user' do
      let!(:essay_submission) { create(:essay_submission, user: user) }
      let!(:essay_expired) do
        create(:essay_submission,
               created_at: (Time.now.beginning_of_week - 1.day))
      end

      it 'return essay on current week by user' do
        expect(EssaySubmission.current_week_by_user(user.id))
          .to eq([essay_submission])
      end
    end
  end

  describe 'dropper event period' do
    let(:period) { { start_date: Date.today - 7.days, end_date: Date.today - 5.days } }
    let!(:first_essay) { create(:essay_submission, user: user, created_at: period[:start_date]) }
    let!(:second_essay) { create(:essay_submission, user: user, created_at: period[:end_date]) }

    context '.limit_first_essay_by_period' do
      it 'inactivates >= second submission' do
        expect do
          EssaySubmission.limit_first_essay_by_period(period[:start_date], period[:end_date])
        end.to change { second_essay.reload.active }.from(true).to(false)
        expect(first_essay.reload.active).to eq(true)
      end
    end

    context '.activate_by_period' do
      before { first_essay.update(active: false) }
      before { second_essay.update(active: false) }
      it 'activates all submissions on period' do
        expect do
          EssaySubmission.activate_by_period(period[:start_date], period[:end_date])
        end.to change { first_essay.reload.active }.from(false).to(true)
                                                   .and change { second_essay.reload.active }
          .from(false).to(true)
      end
    end
  end

  describe '.stats_by_user' do
    let!(:access) { create(:access_with_duration_and_node, user: user) }
    let(:essay) { create(:essay_submission_with_essay, user: user) }

    context 'when essay is not yet deliveried' do
      it 'returns 0 for both max grade and total of delivered essays' do
        essay.state_machine.transition_to(:correcting)

        expect(EssaySubmission.stats_by_user(user.id))
          .to eq([{ 'max_grade' => '0', 'count' => 0 }])
      end
    end

    context 'when essay is deliveried' do
      before do
        essay.state_machine.transition_to(:correcting)
        essay.update(grades: { "grade_1" => "550", "grade_final" => "550" })
        essay.state_machine.transition_to(:corrected)
        essay.state_machine.transition_to(:delivered)
      end

      it 'returns a list of users max grade and total of delivered essays' do
        expect(EssaySubmission.stats_by_user(user.id))
          .to eq([{ 'max_grade' => '550', 'count' => 1 }])
      end
    end
  end
end
