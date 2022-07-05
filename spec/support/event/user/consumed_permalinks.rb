# frozen_string_literal: true

def consumed_permalinks
  consumed_permalinks = double
  expect(consumed_permalinks).to receive(:response).and_return(
    'aggregations' => { 'group' => { 'buckets' => [
      {
        'key' => 'consumed',
        'max_date' => {
          'hits' => {
            'hits' => [{ '_source' => {
              'created_at' => '2016-12-26 15:26:53 -0200'
            } }]
          }
        }
      }
    ] } }
  )
  consumed_permalinks
end
