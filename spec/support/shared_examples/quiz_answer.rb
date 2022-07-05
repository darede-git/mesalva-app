# frozen_string_literal: true

RSpec.shared_examples 'a question answer with alternative' do |error_msg|
  context 'invalid alternative' do
    it_behaves_like 'a invalid quiz answer alternative', error_msg
  end
  context 'valid alternative' do
    let(:valid_anternative) do
      create(:study_plan_quiz_alternative,
             value: valid_value, question: question)
    end
    it_behaves_like 'a valid quiz answer alternative'
  end
end

RSpec.shared_examples 'a valid date answer' do
  context 'invalid value' do
    context 'value format is not date ISO' do
      before { subject.value = '10/10/2000' }
      it_behaves_like 'a invalid quiz answer with error message',
                      "Data inválida."
    end
    context 'value is not date' do
      before { subject.value = '9999' }
      it_behaves_like 'a invalid quiz answer with error message',
                      "Data inválida."
    end
    context 'value is before today' do
      before do
        Timecop.freeze(Time.now)
        subject.value = Time.now - 1.day
      end
      it_behaves_like 'a invalid quiz answer with error message',
                      "Data inválida."
    end
  end
  context 'valid value' do
    context 'value is today' do
      before do
        Timecop.freeze(Time.now)
        subject.value = Time.now
      end
      it_behaves_like 'a valid subject'
    end
    context 'value is after today' do
      before do
        subject.value = Time.now + 1.day
      end
      it_behaves_like 'a valid subject'
    end
  end
end

RSpec.shared_examples 'a invalid quiz answer with error message' do |message|
  it 'returns .valid? as false' do
    expect(subject.valid?).to be_falsey
    expect(subject.errors.messages)
      .to eq(answer: [message])
  end
end

RSpec.shared_examples 'a invalid quiz answer value' do |message|
  before do |current_test|
    subject.value = current_test.metadata[:value]
  end
  it_behaves_like 'a invalid quiz answer with error message', message
end

RSpec.shared_examples 'a invalid quiz answer alternative' do |message|
  before do
    subject.alternative = invalid_anternative
  end
  it_behaves_like 'a invalid quiz answer with error message', message
end

RSpec.shared_examples 'a valid quiz answer alternative' do
  before do
    subject.alternative = valid_anternative
  end
  it_behaves_like 'a valid subject'
end
