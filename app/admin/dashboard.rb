# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        div do
          br
          text_node %(
                    <iframe
                      src="https://rpm.newrelic.com/public/charts/4luXljcasFb"
                      width="800" height="400" scrolling="no" frameborder="no">
                    </iframe>).html_safe
        end

        div do
          br
          text_node %(
                    <iframe
                      src="https://rpm.newrelic.com/public/charts/2Hjdne5kwLA"
                      width="800" height="400" scrolling="no" frameborder="no">
                    </iframe>).html_safe
        end
      end

      column do
        div do
          br
          text_node %(
                    <iframe
                      src="https://rpm.newrelic.com/public/charts/AbTpqd9TUI"
                      width="800" height="400" scrolling="no" frameborder="no">
                    </iframe>).html_safe
        end

        div do
          br
          text_node %(
                    <iframe
                      src="https://rpm.newrelic.com/public/charts/6JVRlhZZqjp"
                      width="800" height="400" scrolling="no" frameborder="no">
                    </iframe>).html_safe
        end
      end
    end
  end
end
