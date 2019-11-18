#
# @lc app=leetcode id=28 lang=python3
#
# [28] Implement strStr()
#
# https://leetcode.com/problems/implement-strstr/description/
#
# algorithms
# Easy (32.82%)
# Likes:    1026
# Dislikes: 1482
# Total Accepted:    487K
# Total Submissions: 1.5M
# Testcase Example:  '"hello"\n"ll"'
#
# Implement strStr().
#
# Return the index of the first occurrence of needle in haystack, or -1 if
# needle is not part of haystack.
#
# Example 1:
#
#
# Input: haystack = "hello", needle = "ll"
# Output: 2
#
#
# Example 2:
#
#
# Input: haystack = "aaaaa", needle = "bba"
# Output: -1
#
#
# Clarification:
#
# What should we return when needle is an empty string? This is a great
# question to ask during an interview.
#
# For the purpose of this problem, we will return 0 when needle is an empty
# string. This is consistent to C's strstr() and Java's indexOf().
#
#


class Solution:
    def strStr(self, s: str, p: str) -> int:
        if not p:
            return 0
        next_ = self.getNext(p)
        return self.kmp(s, p, next_)

    def kmp(self, s, p, next_):
        len_s, len_p = len(s), len(p)
        i, j = 0, 0
        while i < len_s and j < len_p:
            while j > -1 and s[i] != p[j]:
                j = next_[j]
            i += 1
            j += 1
        if j == len_p:
            return i-j
        else:
            return -1

    def getNext(self, p):
        next_ = [-1] * (len(p)+1)
        i, j = 0, -1
        while i < len(p):
            while j > -1 and p[i] != p[j]:
                j = next_[j]
            i += 1
            j += 1
            next_[i] = j
        return next_

    def findTimes(self, s, p, next_):
        i, j = 0, 0
        cnt = 0
        while i < len(s):
            while j > -1 and s[i] != p[j]:
                j = next_[j]
            if j == len(p)-1:
                cnt += 1
                j = next_[j]  # can voerlap
                # j = -1 # can not overlap
            i += 1
            j += 1
        return cnt


if __name__ == '__main__':
    sol = Solution()
    s = 'abababa'
    p = 'aba'
    next_ = sol.getNext(p)
    cnt = sol.findTimes(s, p, next_)
    # a = sol.strStr("mississippi", "issip")
    print(cnt)
