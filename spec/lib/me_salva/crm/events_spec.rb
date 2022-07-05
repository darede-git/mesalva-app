# frozen_string_literal: true

require 'me_salva/crm/events'
require 'spec_helper'

describe MeSalva::Crm::Events do
  subject { described_class.new }
  let(:client) { double }

  before { mock_setup_intercom_events }

  describe '#create' do
    context 'a valid event' do
      it 'creates an event' do
        expect(subject.create('lesson_watch_web',
                              2,
                              Time.now.to_i,
                              link: link,
                              data: formated_date_time,
                              aula: 'Paga',
                              browser: 'chrome')).to be_nil
      end
    end

    context 'an invalid event' do
      it 'does not an event' do
        expect(subject.create('invalid_event',
                              2,
                              Time.now.to_i,
                              link: link,
                              data: formated_date_time)).to be_falsey
      end
    end
  end

  def formated_date_time
    DateTime.now.strftime('%a, %d %b %Y %H:%M')
  end

  def link
    "#{ENV['DEFAULT_URL']}/#{permalink}"
  end

  def permalink
    "plano-de-estudos-extensivo-2016/matematica/\
#seq-sequencias-numericas-pa-e-pg/seq08-progresso-geometrica-ideia"
  end
end
