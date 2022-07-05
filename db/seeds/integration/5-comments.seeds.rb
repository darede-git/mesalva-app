Comment.create!(text: 'Internal note',
                commenter: Admin.find_by_uid('admin@integration.com'),
                commentable: User.find_by_uid('user@integration.com'),
                token: 'IntErN41n0T3')

Comment.create!(text: 'Exatamente!',
                commenter: User.find_by_uid('user@integration.com'),
                commentable: Medium.last,
                token: 'Token')