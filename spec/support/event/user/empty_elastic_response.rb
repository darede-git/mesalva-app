# frozen_string_literal: true

def empty_elastic_response_double
  empty_elastic_response_double = double
  allow(empty_elastic_response_double).to receive(:response).and_return(
    {
      'aggregations': {
        'modules': {
          'buckets': []
        },
        'node_slugs': {
          'buckets': []
        }
      }
    }.with_indifferent_access
  )
  empty_elastic_response_double
end
