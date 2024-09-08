use aiken/transaction.{
  Mint, OutputReference, ScriptContext, ScriptPurpose, Transaction,
}
use aiken_minting_validator_v2/functions.{consume_utxo, mint_qty}
use aiken_minting_validator_v2/types.{Redeemer}

validator {
  pub fn always_true(_redeemer: Void, _context: ScriptContext) {
    True
  }
}

validator {
  pub fn check_redeemer(redeemer: Int, _context: ScriptContext) {
    (redeemer == 42)?
  }
}

validator {
  pub fn check_redeemer_2(redeemer: Redeemer, _context: ScriptContext) {
    let Redeemer { key, value } = redeemer
    and {
      (key == "Hello, World!")?,
      (value == 42)?,
    }
  }
}

validator(output_reference: OutputReference) {
  pub fn nft(_redeemer: Void, context: ScriptContext) {
    expect Mint(policy_id): ScriptPurpose = context.purpose
    let Transaction { mint, inputs, .. } = context.transaction

    when mint |> mint_qty(policy_id) is {
      1 -> {
        trace @"Is Minting"
        consume_utxo(inputs, output_reference)?
      }
      -1 -> {
        trace @"Is Burning"
        True
      }
      _ -> {
        trace @"Invalid Qty"
        False
      }
    }
  }
}
