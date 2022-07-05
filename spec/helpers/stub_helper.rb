# frozen_string_literal: true

module StubHelper
  def mock_intercom_event
    stub_const('MeSalva::Crm::Events', double)
    allow(MeSalva::Crm::Events).to receive(:create)
      .and_return(nil)
    allow(MeSalva::Crm::Events).to receive(:new)
      .and_return(MeSalva::Crm::Events)
  end

  def mock_intercom_create_user
    mock_intercom_user(create: nil)
  end

  def mock_intercom_update_user
    mock_intercom_user(update: nil, destroy: nil)
  end

  def mock_intercom_user(**verb)
    stub_const('MeSalva::Crm::Users', double(verb))
    allow(MeSalva::Crm::Users).to receive(:new)
      .and_return(MeSalva::Crm::Users)
  end

  def mock_setup_intercom_user(user, methods, attr = {})
    stub_const('Intercom::User', double(user_id: user.id,
                                        email: user.email,
                                        name: user.name,
                                        custom_attributes: attr))
    client_stub(methods)
  end

  def client_stub(methods)
    methods.each do |method|
      allow(client).to receive_message_chain(:users, method)
        .and_return(Intercom::User)
    end
    allow(subject).to receive(:client).and_return(client)
  end

  def mock_setup_intercom_events
    allow(client).to receive_message_chain(:events, :create)
      .and_return(nil)
    allow(subject).to receive(:client).and_return(client)
  end

  def assert_intercom_worker_call(verb)
    expect("#{verb}IntercomUserWorker".constantize).to receive(:perform_async)
  end
end
