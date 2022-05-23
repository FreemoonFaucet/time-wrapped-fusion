# Time Wrapped FSN

## :candy: Basic Wrapped FSN built on the FRC759 standard

### Deposit

There are multiple ways to deposit FSN and receive wrapped tokens.

1. Call ```deposit()```
2. Transfer FSN to this contract

### Withdraw

There are multiple ways to withdraw wrapped tokens and receive FSN.

1. Call ```withdraw(amount)```
2. Transfer wrapped tokens to the contract address ```transfer(contract, amount)```
3. Call ```burn(account, amount)```
4. Transfer wrapped tokens to the zero address ```transfer(address(0), amount)```

| :warning: **Warning** |
| :--- |
| When converting **wrapped tokens/FSN**, only use **whole** tokens and **whole** FSN. |
