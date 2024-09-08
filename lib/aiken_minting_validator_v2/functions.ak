use aiken/dict
use aiken/list
use aiken/transaction.{Input, OutputReference}
use aiken/transaction/value.{MintedValue, PolicyId}

pub fn mint_qty(mint: MintedValue, policy_id: PolicyId) -> Int {
  expect [Pair(_, qty)] =
    mint
      |> value.from_minted_value()
      |> value.tokens(policy_id)
      |> dict.to_pairs()
  qty
}

pub fn consume_utxo(
  transaction_inputs: List<Input>,
  output_reference: OutputReference,
) -> Bool {
  list.any(
    transaction_inputs,
    fn(transaction_input: Input) {
      transaction_input.output_reference == output_reference
    },
  )
}
