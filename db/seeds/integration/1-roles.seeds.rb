# frozen_string_literal: true
# uid: user@integration.com
# access-token: kaTuL76JKSqWb9PmwnQYQA
# token-type: Bearer
# client: WEB
User.create(email: 'user@integration.com',
            birth_date: Date.today - 20.years,
            name: "User Test",
            password: 'user',
            tokens: { 'WEB' => { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9ZS1hlJnR1RY4WeAx1VC6e', 'expiry' => (Time.now + 2.weeks).to_i, 'updated_at' => Time.now.to_s } })

# uid: admin@integration.com
# access-token: LkoOFd6bnxRqk1xJlsQYHA
# token-type: Bearer
# client: WEB
Admin.create(email: 'admin@integration.com',
             password: 'admin',
             tokens: { 'WEB' => { 'token' => '$2a$10$BajF8KeSPRmMNOWq6XKULeczrTseKzteqDLhd/yvbzayJ5JUgsLK.', 'expiry' => (Time.now + 2.weeks).to_i, 'last_token' => nil, 'updated_at' => Time.now.to_s } })

# uid: teacher@integration.com
# access-token: LkoOFd6bnxRqk1xJlsQYHA
# token-type: Bearer
# client: WEB
Teacher.create(email: 'teacher@integration.com',
               password: 'teacher',
               tokens: { 'WEB' => { 'token' => '$2a$10$BajF8KeSPRmMNOWq6XKULeczrTseKzteqDLhd/yvbzayJ5JUgsLK.', 'expiry' => (Time.now + 2.weeks).to_i, 'last_token' => '$2a$10$WX3BJytJutBknbJS8f350eGgcOo4gQLdLlQcZnppqaLIBOAyC/w3K', 'updated_at' => Time.now.to_s } })

# Invitations entities
Teacher.create(name: 'Teacher Guest', email: 'teacher@invitation.com', invitation_token: 'aec53f9d76feda64518ec4e76a1f3fc4b5739c36c78cba47d6eac0f436d3692f')

Admin.create(name: 'Admin Guest', email: 'admin@invitation.com', invitation_token: '960b3896daf17d05f0e241e964a7db5425a59efe2b40c4c41578c9d84e3a8c4c')

# Login entities
User.create(email: 'user@logout.com',
            birth_date: Date.today - 20.years,
            password: 'user',
            tokens: { 'WEB' => { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9ZS1hlJnR1RY4WeAx1VC6e', 'expiry' => (Time.now + 2.weeks).to_i, 'updated_at' => Time.now.to_s } })

User.create(email: 'user@login.com', password: 'user', birth_date: Date.today - 20.years)
Teacher.create(email: 'teacher@login.com', password: 'teacher')
Admin.create(email: 'admin@login.com', password: 'admin')

# Impersonations entity
User.create(email: 'user@impersonations.com',
            birth_date: Date.today - 20.years,
            password: 'user',
            objective_id: 2,
            education_level_id: 2,
            tokens: { 'WEB' => { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9ZS1hlJnR1RY4WeAx1VC6e', 'expiry' => (Time.now + 2.weeks).to_i, 'updated_at' => Time.now.to_s } })

# Cancellation entity
User.create(email: 'user@cancellation.com',
            birth_date: Date.today - 20.years,
            password: 'user',
            tokens: { 'WEB' => { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9ZS1hlJnR1RY4WeAx1VC6e', 'expiry' => (Time.now + 2.weeks).to_i, 'updated_at' => Time.now.to_s } })

# Unsubscribes entity
User.create(email: 'user@unsubscribes.com',
            birth_date: Date.today - 20.years,
            password: 'user',
            tokens: { 'WEB' => { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9ZS1hlJnR1RY4WeAx1VC6e', 'expiry' => (Time.now + 2.weeks).to_i, 'updated_at' => Time.now.to_s } })

# Refunder entity
Admin.create(email: 'admin@refunds.com',
             password: 'admin',
             tokens: { 'WEB' => { 'token' => '$2a$10$BajF8KeSPRmMNOWq6XKULeczrTseKzteqDLhd/yvbzayJ5JUgsLK.', 'expiry' => (Time.now + 2.weeks).to_i, 'last_token' => nil, 'updated_at' => Time.now.to_s } })

# Reset password entities
User.create(provider: 'email', uid: 'user@password.com', email: 'user@password.com', birth_date: Date.today - 20.years)
Teacher.create(provider: 'email', uid: 'teacher@password.com', email: 'teacher@password.com')
Admin.create(provider: 'email', uid: 'admin@password.com', email: 'admin@password.com')

User.create(provider: 'email', birth_date: Date.today - 20.years, uid: 'user@reset.com', encrypted_password: '$2a$10$rS5ILGmGlOL25UwIeUbTbeWciJuEPwQS5bzSzhJ0Oc2dzkZixpPE2', reset_password_token: '4b75d825ca800348a5526ea7d990b0a5e1850bc2a25297c8574e64b544cd561f', reset_password_sent_at: Time.now, email: 'user@reset.com')
Teacher.create(provider: 'email', uid: 'teacher@reset.com', encrypted_password: '$2a$10$rS5ILGmGlOL25UwIeUbTbeWciJuEPwQS5bzSzhJ0Oc2dzkZixpPE2', reset_password_token: '4b75d825ca800348a5526ea7d990b0a5e1850bc2a25297c8574e64b544cd561f', reset_password_sent_at: Time.now, email: 'teacher@reset.com')
Admin.create(provider: 'email', uid: 'admin@reset.com', encrypted_password: '$2a$10$rS5ILGmGlOL25UwIeUbTbeWciJuEPwQS5bzSzhJ0Oc2dzkZixpPE2', reset_password_token: '4b75d825ca800348a5526ea7d990b0a5e1850bc2a25297c8574e64b544cd561f', reset_password_sent_at: Time.now, email: 'admin@reset.com')

User.create(provider: 'email',
            birth_date: Date.today - 20.years,
            uid: 'thu@co.com',
            name: 'Vader',
            email: 'thu@co.com',
            password: 'user',
            tokens: { 'WEB' => { 'token' => '$2a$10$i9sUowLNQY7/XSCylLzGWuG0jb3zYPq9ZS1hlJnR1RY4WeAx1VC6e',
                                 'expiry' => (Time.now + 2.weeks).to_i, 'updated_at' => Time.now.to_s } })
