class V2::PrepTestDetailSerializer
    include FastJsonapi::ObjectSerializer
  
    attributes :token, :weight, :suggestion_type, :options
  end