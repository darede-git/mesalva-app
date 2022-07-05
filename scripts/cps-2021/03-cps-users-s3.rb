# Para casos onde devemos cadastrar muitos alunos ao mesmo tempo baseado em um json hospedado no S3
Net::HTTP.start("cdnqa.mesalva.com") do |http|
 resp = http.get("https://cdnqa.mesalva.com/data/cps_users.json") #link do es json no padrão do arquivo cps_users.json
 users = JSON.parse(resp.body)
 grant_cps_accesses(users)
end


