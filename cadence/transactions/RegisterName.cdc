import FlowNames from "../contracts/FlowNames.cdc"


transaction(name: String, signature: String, content: String) {
  let receiverReference: &FlowNames.Collection{FlowNames.Receiver}

  prepare(acct: AuthAccount) {
    self.receiverReference = acct.borrow<&FlowNames.Collection>(from: FlowNames.CollectionStoragePath) 
        ?? panic("Cannot borrow")
  }

  execute {
    let newDappy <- FlowNames.registerName(name: name, signature: signature)
    newDappy.changeDocument(newUrl: content)
    self.receiverReference.deposit(token: <-newDappy)
  }
}