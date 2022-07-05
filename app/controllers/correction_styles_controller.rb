# frozen_string_literal: true

class CorrectionStylesController < ApplicationController
  before_action -> { authenticate(%w[admin teacher user]) }

  def index
    render_ok(CorrectionStyle.active)
  end
end
