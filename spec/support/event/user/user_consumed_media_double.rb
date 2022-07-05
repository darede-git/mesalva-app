# rubocop:disable Metrics/MethodLength
# frozen_string_literal: true

def user_consumed_media_double(node_module_id = '1')
  {
    'engenharia' => {
      '34' => { 'video' => [630, 631, 621, 622, 623,
                            624, 625, 626, 627, 628,
                            629, 632, 633, 635] },
      '12' => { 'video' => [151, 152] },
      '178' => { 'video' => [2304, 2305, 2309] },
      '215' => { 'video' => [3219] },
      '77' => { 'video' => [931] },
      '201' => { 'video' => [3044] },
      '202' => { 'video' => [3045] },
      '242' => { 'video' => [5449] },
      '6193' => { 'video' => [48_949] },
      '6499' => { 'text' => [54_870] }
    },
    'enem-e-vestibulares' => {
      '4512' => {
        'fixation-exercise' => [45_505, 45_506, 45_507, 45_508, 45_509,
                                45_510, 45_511, 45_512, 45_513, 45_514,
                                45_525, 45_526, 45_527, 45_528, 45_529,
                                45_530, 45_531, 45_532],
        'video' => [45_658, 45_659, 45_660, 45_661]
      },
      '697' => { 'text' => [7631, 7892] },
      '812' => { 'fixation-exercise' => [29_780] },
      '489' => { 'video' => [3548] },
      '490' => { 'video' => [3957] },
      '577' => { 'text' => [7900] },
      '696' => { 'text' => [7888] },
      '6440' => { 'video' => [53_904] }
    },
    'ensino-medio' => {
      node_module_id => { 'video' => [3679, 3682] },
      '120' => { 'video' => [1739] },
      '356' => { 'video' => [6944] },
      '30' => { 'video' => [220] },
      '33' => { 'video' => [657] },
      '122' => { 'video' => [1768] },
      '134' => { 'video' => [3414] },
      '207' => { 'video' => [3061] }
    },
    'concursos' => {
      '286' => {
        'fixation-exercise' => [11_332, 11_333, 11_336, 11_337],
        'video' => [5158]
      },
      '285' => { 'fixation-exercise' => [15_324, 15_537, 15_752] },
      '281' => { 'video' => [1697] }
    },
    'ciencias-da-saude' => {
      '317' => { 'fixation-exercise' => [11_839, 11_840] },
      '315' => { 'video' => [6230] }
    },
    'negocios' => {
      '311' => { 'video' => [5230] },
      '335' => { 'video' => [6341] }
    }
  }
end
# rubocop:enable Metrics/MethodLength
