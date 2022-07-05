# frozen_string_literal: true

pacotes_id = [2781, 2761, 2737, 2928]

features_id = [1, 2, 4]

errors = []

pacotes_id.each do |pacote|
  features_id.each do |feat|
    pf = PackageFeature.new(package_id: pacote, feature_id: feat)

    errors << pf unless pf.save
  end
end

puts erros.inspect
