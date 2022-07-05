Discount.create!(packages: ['1', '2'],
                 name: 'Desconto 20%',
                 starts_at: Time.now - 1.hour,
                 expires_at: Time.now + 10.hour,
                 percentual: 20,
                 code: 'Desconto20',
                 description: 'Desconto de 20% no pacote 1 e 2',
                 token: 'PT2fsrCbdU4u1VpM')
