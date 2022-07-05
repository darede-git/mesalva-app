# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/grid/answer_grid'

describe MeSalva::Grid::AnswerGrid do
  subject { described_class.new(quiz_form_submission, user.id) }

  let(:quiz_form_submission) do
    create(:answer_grid_quiz_form_submission_with_answers)
  end

  let(:url) do
    "#{ENV['S3_CDN']}/data/lps/enem-answer-key/2018/linging_pink.json"
  end

  describe '#check' do
    context 'valid' do
      before do
        file = double
        allow(HTTParty).to receive(:get).with(url).and_return(file)
        allow(file).to receive(:success?).and_return(true)
        allow(file).to receive(:body)
          .and_return(File.read('spec/fixtures/answer_grid.json'))
      end

      it 'returns answer grid' do
        expect(subject.check)
          .to eq(6 => { "correct" => true,
                        "answer" => "A",
                        "alternative-id" => Enem::Answer.last.alternative.id },
                 :answers_correct => 1,
                 :exam => "ling")

        expect { subject.check }
          .to change(Enem::AnswerGrid, :count)
          .by(1).and change(Enem::Answer, :count).by(1)
      end
    end
  end

  describe '#file_exists?' do
    context 'exists' do
      it 'returns true' do
        file = double
        allow(HTTParty).to receive(:get).with(url).and_return(file)
        allow(file).to receive(:success?).and_return(true)

        expect(subject.file_exists?).to be_truthy
      end
    end

    context 'not exists' do
      it 'returns false' do
        file = double
        allow(HTTParty).to receive(:get).with(url).and_return(file)
        allow(file).to receive(:success?).and_return(false)

        expect(subject.file_exists?).to be_falsey
      end
    end
  end
end
