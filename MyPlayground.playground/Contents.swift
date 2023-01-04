
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public var description: String { get{ return "\(val), \(next?.description ?? "")" } }
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

/* ========================================================================= */

//1. Two Sum
//https://leetcode.com/problems/two-sum/

class TwoSum {
    
    // My answer, hash table + two iterations
    // T=O(n), S=O(n)
    func solution1(_ nums: [Int], _ target: Int) -> [Int] {
        var dict = Dictionary<Int, Int>()
        for i in nums.indices {
            dict[nums[i]] = i
        }
        
        for i in nums.indices {
            if let keyOfResidual = dict[target - nums[i]]{
                if keyOfResidual != i {
                    return [i, keyOfResidual]
                }
            }
        }
        return []
    }
}

func twoSumTest() {
    print("twoSum test:");
    print("case 1 answer: ", TwoSum().solution1([2, 7, 11, 5], 9)); // [0, 1]
    print("case 2 answer: ", TwoSum().solution1([], 0)); // []
    print("case 3 answer: ", TwoSum().solution1([0], 0)); // []
    print("case 4 answer: ", TwoSum().solution1([1], 0)); // []
    print("case 5 answer: ", TwoSum().solution1([1], -1)); // []
    print("case 6 answer: ", TwoSum().solution1([Int.max], 0)); // []
    print("case 7 answer: ", TwoSum().solution1([3, 3], 6)); // [0, 1]
    print("case 8 answer: ", TwoSum().solution1([3, -3], 0)); // [0, 1]
    print("case 9 answer: ", TwoSum().solution1([3, 2, 4], 6)); // [1, 2]
    print("case 10 answer: ", TwoSum().solution1([2, 7, 11, 5], 16)); // [2, 3]
    print("case 11 answer: ", TwoSum().solution1([2, 7, -11, 5], -4)); // [1, 2]
}

/* ========================================================================= */

// 222. Count Complete Tree Nodes
// https://leetcode.com/problems/count-complete-tree-nodes/description/

class CountNodes {
    class TreeNode {
        public var val: Int
        public var left: TreeNode?
        public var right: TreeNode?
        public init() { self.val = 0; self.left = nil; self.right = nil; }
        public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
        public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
            self.val = val
            self.left = left
            self.right = right
        }
    }
    
    // My answer, DFS + recursion
    // T=O(N), S=O(logN)
    func solution1(_ root: TreeNode?) -> Int {
        var sum = 0
        if root == nil {
            return sum
        }
        
        sum += 1
        
        if let leftSum = root!.left {
            sum += solution1(leftSum)
        }
        if let rightSum = root!.right {
            sum += solution1(rightSum)
        }
        
        return sum
    }
    
    // solution 1 but cleaner
    // https://leetcode.com/problems/count-complete-tree-nodes/solutions/265456/swift-two-line-solution/
    func solution1_2(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        return 1 + solution1_2(root.left) + solution1_2(root.right)
    }
    
    // find the height of the tree, T=O(log(N)), S=O(log(N))
    func treeHeight(_ root: TreeNode?) -> Int {
        // base case
        guard let root = root else {
            return 0
        }
        
        // because complete tree, left node must exist before right node does
        if root.right != nil {
            return treeHeight(root.right) + 1
        } else {
            return treeHeight(root.left) + 1
        }
    }
    
    // my answer using dc, but it doesn't work
    func solution2(_ root: TreeNode?) -> Int {
        // base case
        guard let root = root else {
//            print("root nil, so 0")
            return 0
        }
        
        // because complete tree, left node must exist before right node does
        if let right = root.right {
            // right exist, so left must be as deep as right
            return ((1 << treeHeight(right)) - 1) + solution2(right) + 1
        } else {
            // right does not exist, so the count is left + 1
            return solution2(root.left) + 1
        }
    }
    
    // the correct answer, T=O(logN*logN), S=O(logN)
    // https://leetcode.com/problems/count-complete-tree-nodes/solutions/2815541/c-dfs-optimized-faster-easy-to-understand/
    func solution2_1(_ root: TreeNode?) -> Int {
        // base case
        guard let root = root else {
            return 0
        }
        
        var l = 1, r = 1
        var left = root.left, right = root.right
        while left != nil {
            left = left!.left
            l += 1
        }
        while right != nil {
            right = right!.right
            r += 1
        }
        
        if l == r {
            return (1 << l) - 1
        }
        
        return solution2_1(root.left) + solution2(root.right) + 1
    }
}

func countNodesTest() {
    print("countNodes test:");
    
    do {
        let n6 = CountNodes.TreeNode(6, nil, nil)
        let n5 = CountNodes.TreeNode(5, nil, nil)
        let n4 = CountNodes.TreeNode(4, nil, nil)
        let n3 = CountNodes.TreeNode(3, n6, nil)
        let n2 = CountNodes.TreeNode(2, n4, n5)
        let n1 = CountNodes.TreeNode(1, n2, n3)
        
        print("case 1: ", CountNodes().solution2_1(n1)) // 6
    }
    
    do {
        print("case 2: ", CountNodes().solution2_1(nil)) // 0
    }
    
    do {
        let n1 = CountNodes.TreeNode(1, nil, nil)
        
        print("case 3: ", CountNodes().solution2_1(n1)) // 1
    }
    
    do {
        let n2 = CountNodes.TreeNode(2, nil, nil)
        let n1 = CountNodes.TreeNode(1, n2, nil)
        
        print("case 4: ", CountNodes().solution2_1(n1)) // 2
    }
    
    do {
        let n4 = CountNodes.TreeNode(4, nil, nil)
        let n3 = CountNodes.TreeNode(3, nil, nil)
        let n2 = CountNodes.TreeNode(2, n4, nil)
        let n1 = CountNodes.TreeNode(1, n2, n3)
        
        print("case 5: ", CountNodes().solution2_1(n1)) // 4
    }
    
    do {
        let n5 = CountNodes.TreeNode(5, nil, nil)
        let n4 = CountNodes.TreeNode(4, nil, nil)
        let n3 = CountNodes.TreeNode(3, nil, nil)
        let n2 = CountNodes.TreeNode(2, n4, n5)
        let n1 = CountNodes.TreeNode(1, n2, n3)
        
        print("case 6: ", CountNodes().solution2_1(n1)) // 5
    }
}

/* ========================================================================= */

// 104. Maximum Depth of Binary Tree
// https://leetcode.com/problems/maximum-depth-of-binary-tree/

class MaxDepth {
    public class TreeNode {
      public var val: Int
      public var left: TreeNode?
      public var right: TreeNode?
      public init() { self.val = 0; self.left = nil; self.right = nil; }
      public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
      public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
          self.val = val
          self.left = left
          self.right = right
      }
    }
    
    func solution1(_ root: TreeNode?) -> Int {
        guard let root = root else {
            return 0
        }
        
        let leftDepth = solution1(root.left)
        let rightDepth = solution1(root.right)
        return (leftDepth > rightDepth ? leftDepth : rightDepth) + 1
    }
}

func testMaxDepth() {
    print("test maxDepth:");
    
    do {
        let n1 = MaxDepth.TreeNode(1, nil, nil)
        
        print("case 0: ", MaxDepth().solution1(n1)) // 1
    }
    do {
        print("case 1: ", MaxDepth().solution1(nil)) // 0
    }
    do {
        print("case 2: ", MaxDepth().solution1(nil)) // 0
    }
    do {
        let n5 = MaxDepth.TreeNode(5, nil, nil)
        let n4 = MaxDepth.TreeNode(4, nil, nil)
        let n3 = MaxDepth.TreeNode(3, nil, nil)
        let n2 = MaxDepth.TreeNode(2, n4, n5)
        let n1 = MaxDepth.TreeNode(1, n2, n3)
        
        print("case 3: ", MaxDepth().solution1(n1)) // 3
    }
    do {
        let n5 = MaxDepth.TreeNode(7, nil, nil)
        let n4 = MaxDepth.TreeNode(15, nil, nil)
        let n3 = MaxDepth.TreeNode(20, n4, n5)
        let n2 = MaxDepth.TreeNode(9, nil, nil)
        let n1 = MaxDepth.TreeNode(3, n2, n3)
        
        print("case 4: ", MaxDepth().solution1(n1)) // 3
    }
}

/* ========================================================================= */

// 121. Best Time to Buy and Sell Stock
// https://leetcode.com/problems/best-time-to-buy-and-sell-stock/

class MaxProfit {
    
    // T=O(N^2), S=O(1) (excluding the input array)
    func solution1(_ prices: [Int]) -> Int {
        var globalMax = 0
        for i in prices.indices {
            var localMax = 0
            for j in i..<prices.count {
                if prices[j] - prices[i] > localMax {
                    localMax = prices[j] - prices[i]
                }
            }
            
            if localMax > globalMax {
                globalMax = localMax
            }
        }
        
        return globalMax
    }
    
    // T=O(N), S=O(1) (excluding the input array)
    func solution2(_ prices: [Int]) -> Int {
        guard prices.count > 1 else {
            return 0
        }
        
        var left = 0, right = 1, maxProfit = 0
        while right < prices.count {
            var profit = prices[right] - prices[left]
            if profit < 0 {
                left = right
                right += 1
            } else {
                maxProfit = max(maxProfit, profit)
                right += 1
            }
        }
        
        return maxProfit
    }
}

func testMaxProfit() {
    print("test maxProfit:");
    
    print(MaxProfit().solution2([])) // 0
    print(MaxProfit().solution2([1, 3, 5])) // 4
    print(MaxProfit().solution2([1, 2])) // 1
    print(MaxProfit().solution2([1, 5, 3])) // 4
    print(MaxProfit().solution2([3, 5, 1])) // 2
    print(MaxProfit().solution2([1, 5, 3, 6])) // 5
    print(MaxProfit().solution2([4, 5, 3, 7])) // 4
}

/* ========================================================================= */

// 322. Coin Change
// https://leetcode.com/problems/coin-change/

class CoinChange {
    
    // T=O(N*M), S=O(N) (Assuming coins.count = M, amount = N)
    func solution1(_ coins: [Int], _ amount: Int) -> Int {
        guard coins.count > 0 && amount >= 0 else {
            return -1
        }
        if amount == 0 {
            return 0
        }
        
        var results = Array<Int>(repeating: -1, count: amount + 1)
        results[0] = 0
        for i in 1...amount {
            var numberOfChanges = Int.max
            for coin in coins {
                if coin <= i && results[i - coin] >= 0 {
                    numberOfChanges = min(numberOfChanges, results[i - coin] + 1)
                    results[i] = numberOfChanges
                }
            }
        }
        
        return results[amount]
    }
}

func testCoinChange() {
    print("test coinChange:");
    
    print(CoinChange().solution1([], 0)) // -1
    print(CoinChange().solution1([1], -1)) // -1
    print(CoinChange().solution1([1], 0)) // 0
    print(CoinChange().solution1([2], 3)) // -1
    print(CoinChange().solution1([1, 2, 5], 11)) // 3
    print(CoinChange().solution1([1, 3, 4], 5)) // 2
    print(CoinChange().solution1([1, 3, 4], 6)) // 2
    print(CoinChange().solution1([1, 2, 5], 8)) // 3
}

/* ========================================================================= */

// 42. Trapping Rain Water
// https://leetcode.com/problems/trapping-rain-water/

class Trap {
    func countTrappedRain(_ map: [Int]) -> Int {
        let bucketHeight = min(map.first!, map.last!)
        var amount = 0
        for height in map {
            amount += max(0, bucketHeight - height)
        }
        
        return amount
    }
    
    func solution1(_ height: [Int]) -> Int {
        guard height.count > 2 else {
            return 0
        }
        
        var total = 0
        var maxLeft = 0, maxRight = 0
        for i in height.indices {
            maxLeft = height[0...i].reduce(into: maxLeft) { result, h in
                result = max(result, h)
            }
            maxRight = height[i..<height.count].reduce(into: maxRight) { result, h in
                result = max(result, h)
            }
            total += max(0, min(maxLeft, maxRight) - height[i])
            maxLeft = 0; maxRight = 0
        }
        
        return total
    }
    
    func solution2(_ height: [Int]) -> Int {
        guard height.count > 1 else {
            return 0
        }
        
        var total = 0
        var maxLeft = Array<Int>(repeating: 0, count: height.count), maxRight = Array<Int>(repeating: 0, count: height.count)
        
        let n = height.count - 1
        maxLeft[0] = height[0]
        maxRight[n] = height[n]
        for i in 1..<height.count {
            maxLeft[i] = max(maxLeft[i - 1], height[i])
            maxRight[n - i] = max(maxRight[n - i + 1], height[n - i])
        }
        
        for i in height.indices {
            total += max(0, min(maxLeft[i], maxRight[i]) - height[i])
        }
        
        return total
    }
    
    func solution3(_ height: [Int]) -> Int {
        guard height.count > 0 else {
            return 0
        }
        
        var total = 0
        var left = 0, right = height.count - 1
        var maxLeft = 0, maxRight = 0
        
        while left < right {
            if height[left] < height[right] {
                if height[left] >= maxLeft {
                    maxLeft = height[left]
                } else {
                    total += maxLeft - height[left]
                }
                left += 1
            } else {
                if height[right] >= maxRight {
                    maxRight = height[right]
                } else {
                    total += maxRight - height[right]
                }
                right -= 1
            }
        }
        
        return total
    }
}

func testTrap() {
    print("test trap:");
    
    print(Trap().solution3([])) // 0
    print(Trap().solution3([10])) // 0
    print(Trap().solution3([2, 5])) // 0
    print(Trap().solution3([5, 2])) // 0
    print(Trap().solution3([2, 5, 3])) // 0
    print(Trap().solution3([3, 2, 5])) // 1
    print(Trap().solution3([0,1,0,2,1,0,1,3,2,1,2,1])) // 6
    print(Trap().solution3([4,2,0,3,2,5])) // 9
}

/* ========================================================================= */

// 2. Add Two Numbers
// https://leetcode.com/problems/add-two-numbers/

class AddTwoNumbers {
    public class ListNode {
        public var val: Int
        public var next: ListNode?
        public var description: String { get{ return "\(val), \(next?.description ?? "")" } }
        public init() { self.val = 0; self.next = nil; }
        public init(_ val: Int) { self.val = val; self.next = nil; }
        public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
    }
    
    func listAdd(_ l: ListNode?, _ r: ListNode?, _ carry: Int) -> ListNode? {
        if l == nil && r == nil {
            if carry > 0 {
                return ListNode(carry)
            }
            return nil;
        }
        
        let sum = (l ?? ListNode(0)).val + (r ?? ListNode(0)).val + carry
        
        return ListNode(sum % 10,
                        listAdd(l?.next, r?.next, sum / 10))
    }
    
    // T=O(N), S=O(N)
    func solution1(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        return listAdd(l1, l2, 0)
    }
    
    // T=O(N), S=O(1)
    func solution2(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var carry = 0
        var node: ListNode? = ListNode(), sum = node
        var l1 = l1, l2 = l2
        while l1 != nil || l2 != nil || carry > 0 {
            var sum = ((l1?.val ?? 0) + (l2?.val ?? 0)) + carry
            node?.next = ListNode(sum % 10)
            carry = sum / 10
            
            node = node?.next
            l1 = l1?.next
            l2 = l2?.next
        }
        
        return sum?.next
    }
    
    func test() {
        print("test addTwoNumbers:");
        
        do {
            print(solution2(nil, nil)?.description ?? "nothing") // nothing
            print(solution2(ListNode(0), nil)?.description ?? "nothing") // 0,
            print(solution2(ListNode(1), nil)?.description ?? "nothing") // 1,
            print(solution2(nil, ListNode(1))?.description ?? "nothing") // 1,
            print(solution2(ListNode(0), ListNode(0))?.description ?? "nothing") // 0,
            print(solution2(ListNode(0), ListNode(1))?.description ?? "nothing") // 1,
            print(solution2(ListNode(1), ListNode(0))?.description ?? "nothing") // 1,
            print(solution2(ListNode(1), ListNode(1))?.description ?? "nothing") // 2,
        }
        
        do {
            let l1 = ListNode(3, ListNode(2, ListNode(1)))
            let l2 = ListNode(6, ListNode(5, ListNode(4)))
            print(solution2(l1, l2)?.description ?? "nothing") // 9, 7, 5
        }
        
        do {
            let l1 = ListNode(1)
            let l2 = ListNode(9, ListNode(1))
            print(solution2(l1, l2)?.description ?? "nothing") // 0, 2
        }
        
        do {
            let l1 = ListNode(1)
            let l2 = ListNode(9, ListNode(9))
            print(solution2(l1, l2)?.description ?? "nothing") // 0, 0, 1
        }
    }
}

/* ========================================================================= */

// 24. Swap Nodes in Pairs
// https://leetcode.com/problems/swap-nodes-in-pairs/

class SwapPairs {
    class ListNode {
        public let val: Int
        public var next: ListNode?
        public var description: String { get{ return "\(val), \(next?.description ?? "")" } }
        public init() { self.val = 0; self.next = nil; }
        public init(_ val: Int) { self.val = val; self.next = nil; }
        public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
    }
    
    // T=O(N), S=O(N) (recursion)
    func solution1(_ head: ListNode?) -> ListNode? {
        guard let head = head else {
            return nil
        }
        if head.next == nil {
            return head
        }
        
        let nextOfNext = solution1(head.next?.next)
        let next = head.next
        next?.next = head
        head.next = nextOfNext
        
        return next
    }
    
    // T=O(N), S=O(1) (iteration, excluding the list)
    func solution2(_ head: ListNode?) -> ListNode? {
        var dummy: ListNode? = ListNode(), prev = dummy, curr = head
        dummy?.next = head
        
        while curr != nil && curr?.next != nil {
            prev?.next = curr?.next
            curr?.next = prev?.next?.next
            prev?.next?.next = curr
            
            prev = curr
            curr = curr?.next
        }
        
        return dummy?.next
    }
    
    func test() {
        print("test swapPairs:");
        
        print(solution2(nil)?.description ?? "nothing") // nothing
        print(solution2(ListNode(0))?.description ?? "nothing") // 0
        print(solution2(ListNode(0, ListNode(1)))?.description ?? "nothing") // 1, 0
        print(solution2(ListNode(0, ListNode(1, ListNode(2))))?.description ?? "nothing") // 1, 0, 2
        print(solution2(ListNode(0, ListNode(1, ListNode(2, ListNode(3)))))?.description ?? "nothing") // 1, 0, 3, 2,
        print(solution2(ListNode(0, ListNode(1, ListNode(2, ListNode(3, ListNode(4))))))?.description ?? "nothing") // 1, 0, 3, 2, 4,
        print(solution2(ListNode(0, ListNode(1, ListNode(2, ListNode(3, ListNode(4, ListNode(5)))))))?.description ?? "nothing") // 1, 0, 3, 2, 5, 4
    }
}

/* ========================================================================= */

// 102. Binary Tree Level Order Traversal
// https://leetcode.com/problems/binary-tree-level-order-traversal/

class LevelOrder {
    
    var levels: [[Int]] = []
    
    func dfs(_ node: TreeNode?, depth: Int) {
        guard let node = node else { return }
        
        if levels.count <= depth {
            levels.append([node.val])
        } else {
            levels[depth].append(node.val)
        }
        
        dfs(node.left, depth: depth + 1)
        dfs(node.right, depth: depth + 1)
    }
    
    // DFS + Array, T=O(N), S=O(logN)
    func solution1(_ root: TreeNode?) -> [[Int]] {
        levels = []
        dfs(root, depth: 0)
        return levels
    }
    
    func test() {
        print("test level order")
        do {
            print("case 1: ", solution1(nil)) // []
        }
        
        do {
            let n1 = TreeNode(1, nil, nil)
            
            print("case 2: ", solution1(n1)) // [[1]]
        }
        do {
            let n5 = TreeNode(7, nil, nil)
            let n4 = TreeNode(15, nil, nil)
            let n3 = TreeNode(20, n4, n5)
            let n2 = TreeNode(9, nil, nil)
            let n1 = TreeNode(3, n2, n3)
            
            print("case 3: ", solution1(n1)) // [[3], [9, 20], [15, 7]]
        }
    }
}

/* ========================================================================= */

// Sorting

class Sort {
    
    public static func quick(_ array: [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        
        let lever = array.last!
        
        var left: [Int] = [], right: [Int] = []
        
        for num in array.prefix(upTo: array.endIndex - 1) {
            if num < lever {
                left.append(num)
            } else {
                right.append(num)
            }
        }
        
        return quick(left) + [lever] + quick(right)
    }
    
    public static func merge(_ array: [Int]) -> [Int] {
        if array.count <= 1 {
            return array
        }

        let left = merge(Array(array[..<(array.count / 2)]))
        let right = merge(Array(array[(array.count / 2)...]))
        
        var sorted: [Int] = []
        var i = 0, j = 0
        while i < left.count && j < right.count {
            if left[i] < right[j] {
                sorted.append(left[i])
                i += 1
            } else {
                sorted.append(right[j])
                j += 1
            }
        }
        
        if i < left.count {
            sorted.append(contentsOf: left[i...])
        } else if j < right.count {
            sorted.append(contentsOf: right[j...])
        }
        
        return sorted
    }
    
    
    public static func test() {
//        print(quick([]))
//        print(quick([0]))
//        print(quick([1, 3, 2]))
//        print(quick([3, 4, 7, 13, 22]))
//        print(quick([31, 24, 17, -13, -22]))
        
        print(merge([]))
        print(merge([0]))
        print(merge([1, 3, 2]))
        print(merge([3, 4, 7, 13, 22]))
        print(merge([31, 24, 17, -13, -22]))
    }
}

/* ========================================================================= */

// 371. Sum of Two Integers
// https://leetcode.com/problems/sum-of-two-integers/

class GetSum {
    
    // Constraint: no explicit + or -
    func solution1(_ a: Int, _ b: Int) -> Int {
        var a = UInt(bitPattern: a), b = UInt(bitPattern: b)
        var sum: UInt = 0, carry: UInt = 0
        while (a != 0 && b != 0) || carry != 0 {
            let bitA = a & 1
            let bitB = b & 1
            sum = sum | (bitA ^ bitB) ^ carry
            carry = (carry != 0) ? (bitA | bitB) : (bitA & bitB)
            a = a >> 1
            b = b >> 1
            sum = sum << 1
        }
        
        return Int(bitPattern: sum)
    }
    
    func solution2(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : solution2(a ^ b, (a & b) << 1)
    }
    
    func solution3(_ a: Int, _ b: Int) -> Int {
        var a = a, b = b
        while b != 0 {
            let c = a & b
            a = a ^ b
            b = c << 1
        }
        return a
    }
    
    func test() {
        print("test get sum")
        print("case 0:", solution3(0, 0)) // 0
        print("case 1:", solution3(0, 1)) // 1
        print("case 2:", solution3(1, 0)) // 1
        print("case 3:", solution3(0, -1)) // -1
        print("case 4:", solution3(1, -1)) // 0
        print("case 5:", solution3(1, 2)) // 3
        print("case 6:", solution3(3, 2)) // 5
    }
}

/* ========================================================================= */

// 49. Group Anagrams
// https://leetcode.com/problems/group-anagrams/

class GroupAnagrams {
    let alpha = [
        Character("a") : 2, Character("b") : 3,
        Character("c") : 5, Character("d") : 7,
        Character("e") : 11, Character("f") : 13,
        Character("g") : 17, Character("h") : 19,
        Character("i") : 23, Character("j") : 29,
        Character("k") : 31, Character("l") : 37,
        Character("m") : 41, Character("n") : 47,
        Character("o") : 53, Character("p") : 59,
        Character("q") : 61, Character("r") : 67,
        Character("s") : 71, Character("t") : 73,
        Character("u") : 79, Character("v") : 83,
        Character("w") : 89, Character("x") : 97,
        Character("y") : 101, Character("z") : 103,
    ]
    
    func sig(_ str: String) -> Double {
        var sig = 1.0
        for c in str {
            sig *= Double(alpha[c] ?? 0)
        }
        
        return sig
    }
    
    func solution1(_ strs: [String]) -> [[String]] {
        var mapping: [Double: [String]] = [:]
        for str in strs {
            if let array = mapping[Double(sig(str))] {
                mapping[Double(sig(str))] = array + [str]
            } else {
                mapping[Double(sig(str))] = [str]
            }
        }
        
        mapping.removeValue(forKey: 0.0)
        return mapping.map { $0.value }
    }
    
    func test() {
        print(solution1([])) // []
        print(solution1(["a"])) // [["a"]]
        print(solution1(["#"])) // [["a"]]
        print(solution1(["eat", "tea", "zzzzzzzzzzzz"])) // [["eat", "tea"], ["bob"]]
    }
}

/* ========================================================================= */

// 179. Largest Number
// https://leetcode.com/problems/largest-number/

class LargestNumber {
    func solution1(_ nums: [Int]) -> String {
        let sorted = nums.sorted { (l: Int, r: Int) in
            let a1 = Int("\(l)" + "\(r)"), a2 = Int("\(r)" + "\(l)")
            return a1! > a2!
        }
        
        let largest = sorted.reduce("") { $0 + "\($1)" }
        if let answer = Int(largest), answer == 0 {
            return answer.description
        } else {
            return largest
        }
    }
    
    func test() {
        print(solution1([0])) // "0"
        print(solution1([0, 0])) // "0"
        print(solution1([18, 199])) // "19918"
        print(solution1([188, 1777, 19])) // "191881777"
        print(solution1([10,2])) // "210"
        print(solution1([3,30,34,5,9])) // "9534330"
        print(solution1([999999998,999999997,999999999])) // "9534330"
    }
}

/* ========================================================================= */

// 26. Remove Duplicates from Sorted Array
// https://leetcode.com/problems/remove-duplicates-from-sorted-array/

class RemoveDuplicates {
    func solution1(_ nums: inout [Int]) -> Int {
        var i = 0, j = 0, index = 0
        while i < nums.count && index < nums.count {
            nums[index] = nums[i]
            index += 1
            
            j = i
            while j < nums.count && nums[j] == nums[i] {
                j += 1
            }
            i = j
        }
        return index
    }
    
    func test() {
        do {
            var a: [Int] = []
            let index = solution1(&a)
            print("\(index), \(a)") // 0, []
        }
        
        do {
            var a: [Int] = [0, 0, 0, 0]
            let index = solution1(&a)
            print("\(index), \(a)") // 1, [0, 0, 0, 0]
        }

        do {
            var a: [Int] = [1, 1, 2, 3, 3]
            let index = solution1(&a)
            print("\(index), \(a)") // 3, [1, 2, 3, 3, 3]
        }
    }
}

/* ========================================================================= */

// 46. Permutations
// https://leetcode.com/problems/permutations/

class Permute {
    func permute(withRoot root: Int, leaves: [Int]) -> [[Int]] {
        guard !leaves.isEmpty else {
            return [[root]]
        }

        var p: [[Int]] = []
        for i in 0..<leaves.count {
            p + permute(withRoot: leaves[i], leaves: (Array(leaves[0..<i]) + Array(leaves[(i + 1)..<leaves.count])))
        }

        return p.map { [root] + $0 }
    }
    
    func solution1(_ nums: [Int]) -> [[Int]] {
        var p: [[Int]] = []
        for i in 0..<nums.count {
            p + permute(withRoot: nums[i], leaves: (Array(nums[0..<i]) + Array(nums[(i + 1)..<nums.count])))
        }

        return p
    }
    
    func test() {
//        print(solution1([])) // []
        print(solution1([0])) // [[0]]
//        print(solution1([0, 1])) // [[0, 1], [1, 0]]
//        print(solution1([0, 1, 2])) // [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]]
    }
}

/* ========================================================================= */

print("Hello, player")

//twoSumTest()
//countNodesTest()
//testMaxDepth()
LevelOrder().test()
