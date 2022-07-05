# frozen_string_literal: true

def medium_count_by_permalink
  permalinks_medium_count = double
  expect(permalinks_medium_count).to receive(:response).and_return(
    'aggregations' => { 'group' => { 'buckets' => [
      {
        'key' => 'ensino-medio',
        'group' => {
          'buckets' => [
            {
              'key' => 'modulo',
              'group' => {
                'buckets' => []
              }
            }
          ]
        }
      }
    ] } }
  )
  permalinks_medium_count
end
