class QueueItem<T> {
    let value: T!
    var next: QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}

///
/// A standard queue (FIFO - First In First Out). Supports simultaneous adding and removing, but only one item can be added at a time, and only one item can be removed at a time.
///
public class Queue<T> {
	typealias Element = T
	
	var front: QueueItem<Element>
	var back: QueueItem<Element>
    var count = 0
	
	init() {
		// Insert dummy item. Will disappear when the first item is added.
		back = QueueItem(nil)
		front = back
	}
    
    func removeAll() {
        // Insert dummy item. Will disappear when the first item is added.
        back = QueueItem(nil)
        front = back
    }
	
	/// Add a new item to the back of the queue.
	func enqueue(value: Element) {
		back.next = QueueItem(value)
		back = back.next!
        count++
	}
	
	/// Return and remove the item at the front of the queue.
	func dequeue () -> Element? {
		if let newhead = front.next {
            count--
			front = newhead
			return newhead.value
		} else {
			return nil
		}
	}
	
	public func isEmpty() -> Bool {
		return front === back
	}
}
