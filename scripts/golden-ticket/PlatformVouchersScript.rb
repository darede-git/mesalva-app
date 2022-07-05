# frozen_string_literal: true

# Versão com muitos alunos, hospedado no s3
def send_vouchers_by_s3_file(file_name)
  Net::HTTP.start("cdnqa.mesalva.com") do |http|
    resp = http.get("https://cdnqa.mesalva.com/data/#{file_name}.json")
    users = JSON.parse(resp.body)
    pp MeSalva::Vouchers::GoldenTicket.new.create_by_users(users)
  end
end

# versão com poucos alunos podendo rodar localmente
def send_vouchers_by_users(users)
  pp MeSalva::Vouchers::GoldenTicket.new.create_by_users(users)
end
