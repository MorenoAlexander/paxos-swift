import Foundation

class Node {
	let nodeId: Int
	var proposalNumber : Int
	var acceptedProposal : String?
	var promiseNumber : Int?

	init(nodeId) {
		self.nodeId = nodeId
		self.proposalNumper = 0
		self.acceptedProposal = nil
		self.promiseNumper = nil
	}

	func prepare(proposalNumber : Int) -> (Int, String?) {
		if self.acceptedProposal == nil {
			self.proposalNumber = proposalNumber
			return (self.nodeId, nil)
		}
		else {
			return (self.nodeId, self.acceptedProposal)
		}
	}

	func accept(proposal : (Int, String)) -> (Int, Bool) {
		let (proposalNumber, value) = proposal
		if self.promiseNumber == nil || proposalNumber >= self.promiseNumber! {
			self.promiseNumber = proposalNumber
			self.acceptedProposal = value
			return (self.nodeId, true)
		} else {
			return (self.nodeId, false)
		}
	}

}

class Paxos {
	let nodes: [Node]

	init (nodeIds: [Int]) {
		self.nodes = nodeIds.map { Node(nodeId: $0) }

	}

	func propose(value: String) {
		let quorum = prepare()
		let accepted = accept(value: value)
		learn(quorum: quorum, accepted: accepted)
	}

	func prepare() -> [(Int, String?)] {
		let proposalNumber = Int.random(in: 0...100)
		let promises = nodes.map { $0.prepare(proposalNumber: proposalNumber) }
		let quorum = getQuorum(response: promises)
		return quorum
	}

	func accept(value: String) -> [(Int, Bool)] {
		let proposal = (promiseNumber!, value)
		let accepts = nodes.map { $0.accept(proposal: proposal) }
		let quorum = getQuorum(responses: accepts)
		return quorum
	}

	func learn(quorum: [(Int, String?)], accepted: [(Int, Bool)]) {
		for node in nodes {
			if node.acceptedProposal != nil {
				print("Learned value: \(node.acceptedProposal!)")
				return
			}
		}
	}

	func getQuorum(responses: [(Int, Any)]) -> [(Int, Any)] {
		return responses.filter { $0.1 != nil }
	}
}

let paxos = Paxos(nodeIds: [1,2,3,4,5])

paxos.propose(value: "Hello, World!")

