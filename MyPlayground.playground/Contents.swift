
//1. Two Sum
//https://leetcode.com/problems/two-sum/

class TwoSum {
    
    
    // My answer, DFS + recursion
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
    
    // My answer, T=O(N), S=O(N)
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
}

func countNodesTest() {
    print("twoSum test:");
    
    do {
        let n6 = CountNodes.TreeNode(6, nil, nil)
        let n5 = CountNodes.TreeNode(5, nil, nil)
        let n4 = CountNodes.TreeNode(4, nil, nil)
        let n3 = CountNodes.TreeNode(3, n6, nil)
        let n2 = CountNodes.TreeNode(2, n4, n5)
        let n1 = CountNodes.TreeNode(1, n2, n3)
        
        print("case 1: ", CountNodes().solution1(n1)) // 6
    }
    
    do {
        print("case 2: ", CountNodes().solution1(nil)) // 0
    }
    
    do {
        let n1 = CountNodes.TreeNode(1, nil, nil)
        
        print("case 3: ", CountNodes().solution1(n1)) // 1
    }
}

/* ========================================================================= */

var greeting = "Hello, player"

print(greeting)

//twoSumTest()
countNodesTest()
