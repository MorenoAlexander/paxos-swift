import Foundation

class Node {
    let nodeId: Int
    var proposalNumber: Int
    var acceptedProposal: String?
    var promiseNumber: Int?
    
    init(nodeId: Int) {
        self.nodeId = nodeId
        self.proposalNumber = 0
        self.acceptedProposal = nil
        self.promiseNumber = nil
    }
    
    func prepare(proposalNumber: Int) -> (Int, String?) {
        if self.acceptedProposal == nil || proposalNumber > self.proposalNumber {
            self.proposalNumber = proposalNumber
            self.promiseNumber = proposalNumber
            return (self.nodeId, nil)
        } else {
            return (self.nodeId, self.acceptedProposal)
        }
    }
    
    func accept(proposal: (Int, String)) -> (Int, Bool) {
        let (proposalNumber, value) = proposal
        if self.promiseNumber == nil || proposalNumber >= self.promiseNumber! {
            self.acceptedProposal = value
            return (self.nodeId, true)
        } else {
            return (self.nodeId, false)
        }
    }
}

class Paxos {
    let nodes: [Node]
    var quorumSize: Int
    var proposalNumber: Int
    
    init(nodeIds: [Int]) {
        self.nodes = nodeIds.map { Node(nodeId: $0) }
        self.quorumSize = nodeIds.count / 2 + 1
        self.proposalNumber = 0
    }
    
    func propose(value: String) {
        proposalNumber += 1
        let quorum = prepare(proposalNumber: proposalNumber)
        if quorum.count >= quorumSize {
            let accepted = accept(value: value)
            if accepted.count >= quorumSize {
                learn(value: value)
                return
            }
        }
        propose(value: value)
    }
    
    func prepare(proposalNumber: Int) -> [(Int, String?)] {
        let promises = nodes.map { $0.prepare(proposalNumber: proposalNumber) }
        return promises.filter { $0.1 != nil }
    }
    
    func accept(value: String) -> [(Int, Bool)] {
        let proposal = (proposalNumber, value)
        let accepts = nodes.map { $0.accept(proposal: proposal) }
        return accepts.filter { $0.1 == true }
    }
    
    func learn(value: String) {
        for node in nodes {
            node.acceptedProposal = value
        }
        print("Learned value: \(value)")
    }
}

let paxos = Paxos(nodeIds: [1, 2, 3, 4, 5])

var hashset = HashSet<String>();

print("Proposing value: Hello, World!")
paxos.propose(value: "Hello, World!")