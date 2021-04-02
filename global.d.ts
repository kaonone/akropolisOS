declare namespace NodeJS {
  export interface Global {
    artifacts: Truffle.Artifacts
    web3: Web3
  }
}
