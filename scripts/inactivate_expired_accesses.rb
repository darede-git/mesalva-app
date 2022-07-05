# frozen_string_literal: true

accesses = Access.where(active: true).where("expires_at < ?", Date.today)
accesses.update(active: false)