class CpsScriptMailer < ApplicationMailer
  default from: 'Me Salva! <naoresponda@mesalva.com>'

  def send_message(email, password)
    message = mail_template("<h2>Sua bolsa chegou!</h2>
    <p>O Me Salva!, em parceria com o Centro Paula Souza, está disponibilizando uma bolsa de estudos para te auxiliar em sua preparação para o ENEM 2021!</p>
    <p>Seu acesso foi criado automaticamente em nossa plataforma. Para ter acesso a todo o conteúdo que o Me Salva! tem a oferecer, siga as instruções abaixo.</p>
    <ul>
        <li>Acesse nosso site pelo link: <a href=\"https://www.mesalva.com/entrar\">mesalva.com/entrar</a></li>
        <li>Clique na opção de <b>continuar com email</b></li>
        <li>Para acessar utilize seu email com final @etec.sp.gov.br:</li>
        <li>Utilize seu CPF como senha (apenas números):</li>
    </ul>
<hr>
    <h3>Seus dados de acesso:</h3>
    <p>
    email: <b>#{email}</b><br>
    senha: <b>#{password}</b><br>
    </p>
<hr>
    <p>Quando completar seu acesso, fique à vontade para navegar na plataforma e explorar as nossas ferramentas. A sua bolsa é válida até 31/12/2021 (ou até a data do ENEM, se ele acontecer em 2022) e dá acesso a todo o conteúdo online (menos a correção de redação) do Me Salva!: plano de estudos personalizado, aulas em vídeo ao vivo e gravadas, exercícios, simulados, simuladinhos, bancos de prova e mais.</p>
    <p>Aproveite e vamos aprovar juntos em 2021! </p>")
    mail(to: email, subject: 'Sua bolsa chegou!', body: message, content_type: "text/html")
  end

  def mail_template(content)
    "<!DOCTYPE html>
<html>
<head>
    <meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\" />
</head>
<body>
<table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" bgcolor=\"#f9f9f9\"
       style=\"background-color:#f9f9f9;border-collapse:collapse;line-height:100%!important;margin:0;padding:0;width:100%!important\">
    <tbody>
    <tr>
        <td>
            <table style=\"border-collapse:collapse;margin:auto;max-width:635px;min-width:320px;width:100%\">
                <tbody>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td valign=\"top\" style=\"padding:0 20px\">

                        <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\"
                               style=\"background-clip:padding-box;border-collapse:collapse;border-radius:3px;color:#545454;font-family:'Helvetica Neue',Arial,sans-serif;font-size:13px;line-height:20px;margin:0 auto;width:100%\">
                            <tbody>
                            <tr>
                                <td valign=\"top\">
                                    <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"
                                           style=\"border:none;border-collapse:separate;font-size:1px;height:2px;line-height:3px;width:100%\">
                                        <tbody>
                                        <tr>
                                            <td valign=\"top\"
                                                style=\"background-color:#ed4343;border:none;font-family:'Helvetica Neue',Arial,sans-serif;width:100%\"
                                                bgcolor=\"#0565FF\">&nbsp;
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"
                                           style=\"background-clip:padding-box;border-collapse:collapse;border-color:#dddddd;border-radius:0 0 3px 3px;border-style:solid solid none;border-width:0 1px 1px;width:100%\">
                                        <tbody>
                                        <tr>
                                            <td style=\"background-clip:padding-box;background-color:white;border-radius:0 0 3px 3px;color:#525252;font-family:'Helvetica Neue',Arial,sans-serif;font-size:15px;line-height:22px;overflow:hidden;padding:40px 40px 30px\"
                                                bgcolor=\"white\">


                                                #{content}

                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            </tbody>
                        </table>

                        <div>
                            <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"
                                   align=\"center\"
                                   style=\"border-collapse:collapse;margin:0 auto;max-width:100%;width:100%\">
                                <tbody>
                                <tr>
                                    <td valign=\"top\" width=\"100%\">
                                        <img alt=\"\"
                                             src=\"https://ci3.googleusercontent.com/proxy/Qxbmwgrm1SkOmm2c0-rI1AcPU2RQ5I4tqvzNo18wwsLMO0azX-gOFsuF2-nQ68tMm5Utdr4nKFyyxEjcMMbDTC_MICwKLlJ0VWh74rwZ6XgT9unzKOQ2aBVrkxBR_srUo8KStH6sMG2VwFdCXJai5g5Wt717BDnZyMqcbZ1O3Il3Jj7b3t-RG0hhd9bvE5qJ3gHHXZ2xaG2GE6hg5rJaAkH8y-w=s0-d-e1-ft#https://kissflow-320b46542f65.intercom-mail.com/assets/email/personal/arrow-37f6774809df6fd083bfc98e9d562e23ca6ede618e2b5e10c042de88d2f858dd.png\"
                                             style=\"max-width:100%;width:100%\">
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\"
                               style=\"border-collapse:collapse;color:#545454;font-family:'Helvetica Neue',Arial,sans-serif;font-size:13px;line-height:20px;margin:0 auto;max-width:100%;width:100%\">
                            <tbody>
                            <tr>
                            </tr>
                            </tbody>
                        </table>
                        <font color=\"#888888\">
                        </font><font color=\"#888888\">
                    </font>
                        <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">
                            <tbody>
                            <tr>
                                <td width=\"75%\">
                                    <font color=\"#888888\"
                                          style=\"color:#545454;font-family:'Helvetica Neue',Arial,sans-serif;\">
                                        Atenciosamente,<br />Equipe Me Salva!
                                    </font></td>
                            </tr>
                            </tbody>
                        </table>
                        <font color=\"#888888\">
                        </font></td>
                </tr>
                </tbody>
            </table>
            <font color=\"#888888\">
            </font></td>
    </tr>
    </tbody>
</table>
</body>
</html>
"
  end
end
