
import heapq

class Heap(list):
    """This is a wrapper class for the heap functions provided
    by the heapq module.
    """
    __slots__ = ()
    
    def __init__(self, t=[]):
        self.extend(t)
        self.heapify()

    def heapify(self): heapq.heapify(self)
    def push(self, item): heapq.heappush(self, item)
    def popmin(self): return heapq.heappop(self)
    def replace(self, item): return heapq.heapreplace(self, item)

    def peek(self): return self[0]

    def pushpop(self, item):
        "Pushes the item onto the heap and then pop the smallest value"
        if self and self[0] < item:
            return heapq.heapreplace(self, item)
        return item

    def __iter__(self):
        "Returns a destructive iterator over the heap's elements"
        try:
            while True:
                yield self.popmin()
        except IndexError:
            pass

    def reduce(self, pos, newitem):
        "Replaces self[pos] with a lower value item and reheapifies."
        while pos > 0:
            parentpos = (pos - 1) >> 1
            parent = self[parentpos]
            if parent <= newitem:
                break
            self[pos] = parent
            pos = parentpos
        self[pos] = newitem

    def is_heap(self):
        "Returns True if the heap has the heap property; False otherwise"
        n = len(self)
        # The largest index there's any point to looking at
        # is the largest with a child index in-range, so must have 2*i + 1 < n,
        # or i < (n-1)/2.  If n is even = 2*j, this is (2*j-1)/2 = j-1/2 so
        # j-1 is the largest, which is n//2 - 1.  If n is odd = 2*j+1, this is
        # (2*j+1-1)/2 = j so j-1 is the largest, and that's again n//2-1.
        try:
            for i in xrange(n//2):
                if self[i] > self[2*i+1]: return False
                if self[i] > self[2*i+2]: return False
        except IndexError:
            pass
        return True
        

def heapsort(seq):
    """Makes a new sorted list from a sequence.

    Uses a Heap.
    """
    return [x for x in Heap(seq)]


if __name__ == '__main__':
    from random import randint, shuffle

    # generate a random test case
    n = 15
    data = [randint(1,n) for i in xrange(n)]
    shuffle(data)
    print data

    # test the constructor
    heap = Heap(data)
    print heap, heap.is_heap()

    # test popmin
    sorted = []
    while heap:
        sorted.append(heap.popmin())
    
    data.sort()
    print heap, heap.is_heap()
    print data == sorted

    # test 2
    shuffle(data)
    print data

    # test push
    for item in data:
        heap.push(item)
    print heap, heap.is_heap()

    # test __iter__
    sorted = [x for x in heap]

    data.sort()
    print data == sorted

    # test 3
    shuffle(data)
    print data
    heap = Heap(data)
    print heap, heap.is_heap()

    # test reduce
    for i in range(5):
        pos = randint(0,n-1)
        decr = randint(1,10)
        item = heap[pos] - decr
        heap.reduce(pos, item)

    # test is_heap
    heap = Heap(data)
    count = 0
    while 1:
        shuffle(heap)
        if heap.is_heap():
            print heap
            break
        else:
            count += 1
    print 'It took', count, 'tries to find a heap by chance.'

    print heapsort(data)
    
    try:
        heap.x = 5
    except AttributeError:
        print "Can't add attributes."