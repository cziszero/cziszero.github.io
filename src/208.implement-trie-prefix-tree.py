#
# @lc app=leetcode id=208 lang=python3
#
# [208] Implement Trie (Prefix Tree)
#
# https://leetcode.com/problems/implement-trie-prefix-tree/description/
#
# algorithms
# Medium (40.34%)
# Likes:    1838
# Dislikes: 35
# Total Accepted:    199.8K
# Total Submissions: 494.6K
# Testcase Example:  '["Trie","insert","search","search","startsWith","insert","search"]\n[[],["apple"],["apple"],["app"],["app"],["app"],["app"]]'
#
# Implement a trie with insert, search, and startsWith methods.
#
# Example:
#
#
# Trie trie = new Trie();
#
# trie.insert("apple");
# trie.search("apple");   // returns true
# trie.search("app");     // returns false
# trie.startsWith("app"); // returns true
# trie.insert("app");
# trie.search("app");     // returns true
#
#
# Note:
#
#
# You may assume that all inputs are consist of lowercase letters a-z.
# All inputs are guaranteed to be non-empty strings.
#
#
#
from collections import defaultdict


class TrieNode:
    def __init__(self):
        self.childs = defaultdict(TrieNode)
        self.isWord = False


class Trie:

    def __init__(self):
        """
        Initialize your data structure here.
        """
        self.root = TrieNode()

    def insert(self, word: str) -> None:
        """
        Inserts a word into the trie.
        """
        r = self.root
        for ch in word:
            r = r.childs[ch]
        r.isWord = True

    def search(self, word: str) -> bool:
        """
        Returns if the word is in the trie.
        """
        r = self.root
        for ch in word:
            if ch not in r.childs:
                return False
            else:
                r = r.childs[ch]
        return r.isWord

    def startsWith(self, prefix: str) -> bool:
        """
        Returns if there is any word in the trie that starts with the given prefix.
        """
        r = self.root
        for ch in prefix:
            if ch not in r.childs:
                return False
            else:
                r = r.childs[ch]
        return True


# Your Trie object will be instantiated and called as such:
# obj = Trie()
# obj.insert(word)
# param_2 = obj.search(word)
# param_3 = obj.startsWith(prefix)
