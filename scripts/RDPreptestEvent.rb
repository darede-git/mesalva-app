PrepTestOverview.where('id < ?', 243053).take

pretest_submissions = PrepTestOverview.where("permalink_slug LIKE 'enem-e-vestibulares/simulados/2-simuladao-enem-2021/%'").where('id < ?', 243053)
pretest_submissions.each do |pretest_submission|
  user = User.find_by_uid(pretest_submission.user_uid)
  submission_token = pretest_submission.token
  permalink = Permalink.find_by_slug(pretest_submission.permalink_slug)
  item = permalink.item
  node_module = permalink.node_module
  send_rd_station_event(event: :prep_test_answer,
                        params: { user: user,
                                  submission_token: submission_token,
                                  item: item,
                                  node_module: node_module })
end
