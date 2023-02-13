class HashSet<T: Hashable> {
	let initialCapacity = 16;
	var buckets: [[T]?]
	var count = 0

	init() {
		buckets = Array<Any?>(repeating: nil, count: initialCapacity)
	}

	func add(_ value: T) {
		if contains(value) {
			return
		}

		let hashValue = value.hashValue
		let index = hashValue % buckets.count

		if buckets[index] == nil {
			buckets[index] = [value]
		}
		else {
			buckets[index]!.append(value)
		}

		count += 1

		let loadFactor = Double(count) / Double(buckets.count)
		if loadFactor > 0.75 {
			resize()
		}
	}

	func contains(_ value: T) -> Bool {
		let hashValue = value.hashValue
		let index = hashValue % buckets.count

		if buckets[index] == nil {
			return false
		} else {
			for element in buckets[index]! {
				if element == value {
					return true
				}
			}

			return false
		}
	}

	func resize() {
		let newCapacity = buckets.count * 2
		var newBuckets = Array<Any?>(repeating: nil, count: newCapacity)

		for bucket in buckets {
			if bucket != nil {
				for value in bucket! {
					let hashValue = value.hashValue
					let index = hashValue % newCapacity

					if newBuckets[index] == nil {
						newBuckets[index] = [value]
					} else {
						newBuckets[index]!.append(value)
					}
				}
			}
		}

		buckets = newBuckets
	}
}