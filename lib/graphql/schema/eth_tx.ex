defmodule Insur3.Graphql.Schema.EthTx do
  use Absinthe.Schema.Notation
  alias Insur3.EthTx

  object :policy do
    field(:policy_id, :integer)
    field(:name, :string)
    field(:event_name, :string)
    field(:underwrite_id, :integer)
    field(:issue_timestamp, :datetime)
    field(:expiry_timestamp, :datetime)
    field(:settlement_token, :string)
    field(:settlement_token_address, :string)
    field(:premium_token_id, :integer)
    field(:coverage_token_id, :integer)
    field(:open_interest, :string)
    field(:policy_uri, :string)
    field(:multiplier, :string)
    field(:policy_address, :string)
    field(:underwrite_address, :string)
    field(:underwrite_issuer, :string)
    field(:underwrite_uri, :string)
    field(:underwrite_total_underwriter, :integer)
    field(:underwrite_minimum_approval, :integer)
    field(:underwrite_open_inspect_time_gap, :integer)
    field(:latest_order_price, :string)
    field(:latest_order_type, :integer)
    field(:latest_order_block_number, :integer)
  end

  object :policy_by_underwrite_response do
    field(:underwrite_id, :integer)
    field(:policies, list_of(:policy))
  end

  object :policy_exchange_feed_response do
    field(:underwrite_id, :integer)
    field(:underwrite_name, :string)
    field(:settlement_token, :string)
    field(:result, list_of(:policy))
  end

  object :policies_exchange_feed_response do
    field(:policies, list_of(:policy_exchange_feed_response))
  end

  object :policy_by_underwrite do
    field :policy_by_underwrite, :policy_by_underwrite_response do
      arg(:underwrite_id, non_null(:integer))

      resolve(fn _, args, _ ->
        EthTx.call(:get_policy_by_underwrite, {args.underwrite_id})
      end)
    end
  end

  object :policy_exchange_feed do
    field :policy_exchange_feed, :policies_exchange_feed_response do
      resolve(fn _, args, _ ->
        EthTx.call(:get_policy_exchange_feed, {})
      end)
    end
  end

  object :underwrite do
    field(:underwrite_id, :integer)
    field(:total_underwriter, :integer)
    field(:minimum_approval, :integer)
    field(:name, :string)
    field(:event_name, :string)
    field(:underwrite_uri, :string)
    field(:issuer, :string)
    field(:open_inspect_time_gap, :integer)
    field(:claim_approve, :boolean)
    field(:claim_timestamp, :integer)
    field(:total_inspect, :integer)
  end

  object :underwrite_response do
    field(:underwrites, list_of(:underwrite))
  end

  object :get_underwrite do
    field :get_underwrite, :underwrite_response do
      resolve(fn _, args, _ ->
        EthTx.call(:get_underwrite, {})
      end)
    end
  end

  object :sub_policy do
    field :policy, :policy do
      arg(:policy_id, non_null(:integer))

      config(fn args, _info ->
        {:ok, topic: args.policy_id}
      end)

      resolve(fn root, _, _ -> root end)
    end
  end

  object :order_info do
    field(:order_type, :integer)
    field(:policy_id, :integer)
    field(:order_id, :integer)
    field(:price, :decimal)
    field(:amount, :integer)
    field(:fee, :string)
    field(:user, :string)
    field(:updated, :datetime)
  end

  object :order_info_grouping do
    field(:orders, list_of(:order_info))
    field(:price, :string)
    field(:amount, :integer)
  end

  object :place_order_info_response do
    field(:policy_id, :integer)
    field(:bid_premiums, list_of(:order_info_grouping))
    field(:offer_premiums, list_of(:order_info_grouping))
    field(:bid_coverages, list_of(:order_info_grouping))
    field(:offer_coverages, list_of(:order_info_grouping))
  end

  object :place_order_info do
    field :place_order_info, :place_order_info_response do
      arg(:policy_id, non_null(:integer))

      resolve(fn _, args, _ ->
        EthTx.call(:get_place_order_info, {args.policy_id})
      end)
    end
  end

  object :sub_place_order_info do
    field :place_order_info, :place_order_info_response do
      arg(:policy_id, non_null(:integer))

      config(fn args, _info ->
        {:ok, topic: Map.get(args, :policy_id)}
      end)

      resolve(fn root, _, _ -> root end)
    end
  end

  object :open_order do
    field(:user, :string)
    field(:policy_id, :integer)
    field(:order_id, :integer)
    field(:name, :string)
    field(:settlement_token, :string)
    field(:order_type, :integer)
    field(:price, :decimal)
    field(:amount, :integer)
    field(:expiry, :datetime)
    field(:total_value, :decimal)
    field(:tx_hash, :string)
    field(:created, :datetime)
    field(:updated, :datetime)
  end

  object :history_order do
    field(:user, :string)
    field(:policy_id, :integer)
    field(:name, :string)
    field(:settlement_token, :string)
    field(:underwrite_id, :integer)
    field(:order_type, :integer)
    field(:amount, :integer)
    field(:total_value, :decimal)
    field(:tx_hash, :string)
    field(:expiry, :datetime)
    field(:created, :datetime)
  end

  object :portfolio do
    field(:user, :string)
    field(:status, :integer)
    field(:policy_id, :integer)
    field(:policy_token_id, :integer)
    field(:product_type, :integer)
    field(:underwrite_id, :integer)
    field(:name, :string)
    field(:settlement_token, :string)
    field(:amount, :integer)
    field(:expiry, :datetime)
    field(:updated, :datetime)
  end

  object :order_history_response do
    field(:user, :string)
    field(:open_orders, list_of(:open_order))
    field(:history_orders, list_of(:history_order))
    field(:portfolios, list_of(:portfolio))
  end

  object :order_history do
    field :order_history, :order_history_response do
      arg(:user, non_null(:string))

      resolve(fn _, args, _ ->
        EthTx.call(:get_order_history, {args.user})
      end)
    end
  end

  object :sub_order_history do
    field :order_history, :order_history_response do
      arg(:user, non_null(:string))

      config(fn args, _info ->
        {:ok, topic: String.downcase(args.user)}
      end)

      resolve(fn root, _, _ -> root end)
    end
  end

  object :latest_order_response do
    field(:underwrite_id, :string)
    field(:latest_orders, list_of(:history_order))
  end

  object :latest_order do
    field :latest_order, :latest_order_response do
      arg(:underwrite_id, non_null(:integer))

      resolve(fn _, args, _ ->
        EthTx.call(:get_latest_order, {args.underwrite_id})
      end)
    end
  end

  object :sub_latest_order do
    field :latest_order, :latest_order_response do
      arg(:underwrite_id, non_null(:integer))

      config(fn args, _info ->
        {:ok, topic: args.underwrite_id}
      end)

      resolve(fn root, _, _ -> root end)
    end
  end

  object :product do
    field(:status, :integer)
    field(:underwrite_id, :integer)
    field(:policy_id, :integer)
    field(:policy_token_id, :integer)
    field(:product_type, :integer)
    field(:name, :string)
    field(:settlement_token, :string)
    field(:expiry, :datetime)
    field(:price, :decimal)
    field(:block_number, :integer)
    field(:updated, :datetime)
  end

  object :product_response do
    field(:products, list_of(:portfolio))
  end

  object :product_list do
    field :product, :product_response do
      resolve(fn _, args, _ ->
        EthTx.call(:get_product, {false})
      end)
    end
  end
end
