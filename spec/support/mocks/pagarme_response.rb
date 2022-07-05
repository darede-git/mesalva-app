# rubocop:disable Metrics/MethodLength
# frozen_string_literal: true

def valid_postback_request
  @request = double
  request_body = double
  allow(request_body).to receive_messages(string:
    "id=3487265&fingerprint=ad188b7cf4b6e0be388d73a096b8e718d45b4557&event=tr"\
    "ansaction_status_changed&old_status=processing&desired_status=paid&curren"\
    "t_status=paid&object=transaction&transaction%5Bobject%5D=transaction&tran"\
    "saction%5Bstatus%5D=paid&transaction%5Brefuse_reason%5D=&transaction%5Bst"\
    "atus_reason%5D=acquirer&transaction%5Bacquirer_response_code%5D=0000&tran"\
    "saction%5Bacquirer_name%5D=pagarme&transaction%5Bacquirer_id%5D=58e3e5ee6"\
    "45a1448734bad72&transaction%5Bauthorization_code%5D=131018&transaction%5B"\
    "soft_descriptor%5D=&transaction%5Btid%5D=3487265&transaction%5Bnsu%5D=348"\
    "7265&transaction%5Bdate_created%5D=2018-05-14T00%3A45%3A11.788Z&transacti"\
    "on%5Bdate_updated%5D=2018-05-14T00%3A45%3A12.351Z&transaction%5Bamount%5D"\
    "=31920&transaction%5Bauthorized_amount%5D=31920&transaction%5Bpaid_amount"\
    "%5D=31920&transaction%5Brefunded_amount%5D=0&transaction%5Binstallments%5"\
    "D=1&transaction%5Bid%5D=3487265&transaction%5Bcost%5D=29&transaction%5Bca"\
    "rd_holder_name%5D=Andre%20Antunes%20Vieira&transaction%5Bcard_last_digits"\
    "%5D=1111&transaction%5Bcard_first_digits%5D=411111&transaction%5Bcard_bra"\
    "nd%5D=visa&transaction%5Bcard_pin_mode%5D=&transaction%5Bpostback_url%5D="\
    "http%3A%2F%2Fqa.apiv2.mesalva.com%2Fpostbacks&transaction%5Bpayment_metho"\
    "d%5D=credit_card&transaction%5Bcapture_method%5D=ecommerce&transaction%5B"\
    "antifraud_score%5D=&transaction%5Bboleto_url%5D=&transaction%5Bboleto_bar"\
    "code%5D=&transaction%5Bboleto_expiration_date%5D=&transaction%5Breferer%5"\
    "D=api_key&transaction%5Bip%5D=54.226.57.30&transaction%5Bsubscription_id%"\
    "5D=&transaction%5Bphone%5D%5Bobject%5D=phone&transaction%5Bphone%5D%5Bddi"\
    "%5D=55&transaction%5Bphone%5D%5Bddd%5D=51&transaction%5Bphone%5D%5Bnumber"\
    "%5D=993472756&transaction%5Bphone%5D%5Bid%5D=235544&transaction%5Baddress"\
    "%5D=&transaction%5Bcustomer%5D%5Bobject%5D=customer&transaction%5Bcustome"\
    "r%5D%5Bid%5D=416098&transaction%5Bcustomer%5D%5Bexternal_id%5D=&transacti"\
    "on%5Bcustomer%5D%5Btype%5D=&transaction%5Bcustomer%5D%5Bcountry%5D=&trans"\
    "action%5Bcustomer%5D%5Bdocument_number%5D=01529151090&transaction%5Bcusto"\
    "mer%5D%5Bdocument_type%5D=cpf&transaction%5Bcustomer%5D%5Bname%5D=Andre%2"\
    "0Antunes%20Vieira&transaction%5Bcustomer%5D%5Bemail%5D=andreantunesv%40gm"\
    "ail.com&transaction%5Bcustomer%5D%5Bphone_numbers%5D=&transaction%5Bcusto"\
    "mer%5D%5Bborn_at%5D=&transaction%5Bcustomer%5D%5Bbirthday%5D=&transaction"\
    "%5Bcustomer%5D%5Bgender%5D=&transaction%5Bcustomer%5D%5Bdate_created%5D=2"\
    "017-12-12T22%3A05%3A31.870Z&transaction%5Bbilling%5D=&transaction%5Bshipp"\
    "ing%5D=&transaction%5Bcard%5D%5Bobject%5D=card&transaction%5Bcard%5D%5Bid"\
    "%5D=card_cjh5irc0c061nw36ecdp2j39y&transaction%5Bcard%5D%5Bdate_created%5"\
    "D=2018-05-14T00%3A37%3A36.781Z&transaction%5Bcard%5D%5Bdate_updated%5D=20"\
    "18-05-14T00%3A37%3A37.310Z&transaction%5Bcard%5D%5Bbrand%5D=visa&transact"\
    "ion%5Bcard%5D%5Bholder_name%5D=Andre%20Antunes%20Vieira&transaction%5Bcar"\
    "d%5D%5Bfirst_digits%5D=411111&transaction%5Bcard%5D%5Blast_digits%5D=1111"\
    "&transaction%5Bcard%5D%5Bcountry%5D=UNITED%20STATES&transaction%5Bcard%5D"\
    "%5Bfingerprint%5D=cj5bw4cio00000j23jx5l60cq&transaction%5Bcard%5D%5Bvalid"\
    "%5D=true&transaction%5Bcard%5D%5Bexpiration_date%5D=0619&transaction%5Bsp"\
    "lit_rules%5D=&transaction%5Bmetadata%5D%5Bbairro%5D=&transaction%5Bmetada"\
    "ta%5D%5Bcep%5D=&transaction%5Bmetadata%5D%5Bcidade%5D=&transaction%5Bmeta"\
    "data%5D%5Bcomplemento%5D=&transaction%5Bmetadata%5D%5Bdata-da-compra%5D=2"\
    "018-05-14T00%3A45%3A11.691%2B00%3A00&transaction%5Bmetadata%5D%5Bestado%5"\
    "D=&transaction%5Bmetadata%5D%5Blogradouro%5D=&transaction%5Bmetadata%5D%5"\
    "Bnome%5D=Andre%20Antunes%20Vieira&transaction%5Bmetadata%5D%5Bnumero%5D=&"\
    "transaction%5Bmetadata%5D%5Bproduto-comprado%5D=Anual%20Neg%C3%B3cios&tra"\
    "nsaction%5Bmetadata%5D%5Btempo-de-dura%C3%A7%C3%A3o-do-produto%5D=12&tran"\
    "saction%5Bmetadata%5D%5Buser_id%5D=14&transaction%5Breference_key%5D=&tra"\
    "nsaction%5Bdevice%5D=&transaction%5Blocal_transaction_id%5D=&transaction%"\
    "5Blocal_time%5D=&transaction%5Bfraud_covered%5D=false&transaction%5Border"\
    "_id%5D=&transaction%5Brisk_level%5D=unknown&transaction%5Breceipt_url%5D="\
    "&transaction%5Bpayment%5D=")
  allow(@request).to receive_messages(body: request_body)
  allow(@request)
    .to receive_messages(headers:
    { 'X-Hub-Signature' => 'sha1=2ffe50b88c9303c749351092c4d40a3a2c75334f' })
end
# rubocop:enable Metrics/MethodLength
