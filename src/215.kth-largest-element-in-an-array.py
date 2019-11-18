#
# @lc app=leetcode id=215 lang=python3
#
# [215] Kth Largest Element in an Array
#
# https://leetcode.com/problems/kth-largest-element-in-an-array/description/
#
# algorithms
# Medium (49.59%)
# Likes:    2378
# Dislikes: 189
# Total Accepted:    430.9K
# Total Submissions: 867.3K
# Testcase Example:  '[3,2,1,5,6,4]\n2'
#
# Find the kth largest element in an unsorted array. Note that it is the kth
# largest element in the sorted order, not the kth distinct element.
#
# Example 1:
#
#
# Input: [3,2,1,5,6,4] and k = 2
# Output: 5
#
#
# Example 2:
#
#
# Input: [3,2,3,1,2,4,5,5,6] and k = 4
# Output: 4
#
# Note:
# You may assume k is always valid, 1 ≤ k ≤ array's length.
#
#


class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        # nums=[1];k=1
        def partition(l, r, kth):
            i, j = l, r
            m = nums[i]
            while i < j:
                while i < j and nums[j] >= m:
                    j -= 1
                nums[i] = nums[j]
                while i < j and nums[i] < m:
                    i += 1
                nums[j] = nums[i]
            nums[i] = m
            if kth == i - l:
                return nums[i]
            elif kth > i-l:
                return partition(i+1, r, kth-(i-l+1))
            else:
                return partition(l, i, kth)
        return partition(0, len(nums)-1, len(nums)-k)
