# frozen_string_literal: true

module MeSalva
  module Payment
    module Pagarme
      class ErrorCodeModule
        def self.error_message(error_code)
          errors_list[error_code.to_sym]
        end

        # rubocop:disable Metrics/MethodLength
        def self.errors_list
          { '1000': 'Transação não autorizada. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1001': 'Cartão vencido. Dúvidas? Fale com a gente!',
            '1002': 'Transação não permitida. Tente novamente com um cartão de crédito. Dúvidas? Fale com a gente!',
            '1003': 'Rejeitado emissor. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1004': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1005': 'Transação não autorizada. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1006': 'Tentativas de senha excedidas',
            '1007': 'Rejeitado emissor. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1008': 'Rejeitado emissor. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1009': 'Transação não autorizada. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1010': 'Valor inválido',
            '1011': 'Cartão inválido. Dúvidas? Fale com a gente!',
            '1013': 'Transação não autorizada. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1014': 'Tipo de conta inválido. Dúvidas? Fale com a gente!',
            '1016': 'Saldo do cartão insuficiente. Dúvidas? Fale com a gente!',
            '1017': 'Senha inválida',
            '1019': 'Transação não permitida. Tente novamente com um cartão de crédito. Dúvidas? Fale com a gente!',
            '1020': 'Transação não permitida. Tente novamente com um cartão de crédito. Dúvidas? Fale com a gente!',
            '1021': 'Rejeitado emissor. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1022': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1023': 'Rejeitado emissor. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '1024': 'Transação não permitida. Tente novamente com um cartão de crédito. Dúvidas? Fale com a gente!',
            '1025': 'Cartão bloqueado. Dúvidas? Fale com a gente!',
            '1042': 'Tipo de conta inválido',
            '1045': 'Código de segurança inválido. Tente novamente. Dúvidas? Fale com a gente!',
            '2000': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '2001': 'Cartão vencido. Dúvidas? Fale com a gente!',
            '2002': 'Transação não permitida. Tente novamente com um cartão de crédito. Dúvidas? Fale com a gente!',
            '2003': 'Rejeitado emissor. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '2004': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '2005': 'Transação não autorizada. Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '2006': 'Tentativas de senha excedidas',
            '2007': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '2008': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '2009': 'Cartão com restrição.  Ligue para o emissor do seu cartão. Dúvidas? Fale com a gente!',
            '9102': 'Transação inválida. Reescreva seus dados. Dúvidas? Fale com a gente!',
            '9108': 'Erro no processamento. Tente novamente. Dúvidas? Fale com a gente!',
            '9109': 'Erro no processamento. Tente novamente. Dúvidas? Fale com a gente!',
            '9111': 'Time-out na transação. Tente novamente. Dúvidas? Fale com a gente!',
            '9112': 'Emissor indisponível. Tente novamente. Dúvidas? Fale com a gente!',
            '9999': 'Erro genérico. Tente novamente. Dúvidas? Fale com a gente!' }
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
