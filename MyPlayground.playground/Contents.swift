
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

var greeting = "Hello, player"

print(greeting)

//twoSumTest()
countNodesTest()
