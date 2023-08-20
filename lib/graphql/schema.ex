defmodule Insur3.Graphql.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(Insur3.Graphql.Schema.EthTx)

  query do
    import_fields(:get_underwrite)
    import_fields(:policy_exchange_feed)
    import_fields(:policy_by_underwrite)
    import_fields(:place_order_info)
    import_fields(:order_history)
    import_fields(:latest_order)
    import_fields(:product_list)
  end

  subscription do
    import_fields(:sub_policy)
    import_fields(:sub_place_order_info)
    import_fields(:sub_order_history)
    import_fields(:sub_latest_order)
  end

  object :cast_response do
    field(:response_id, :string)
  end
end
