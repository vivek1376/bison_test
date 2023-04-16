#ifndef __TREE_H__
#define __TREE_H__

#define MAX_CHILDREN 32

enum nodeType {
  DECLARATION,
  STATEMENT
};


typedef struct _node {
  struct _node *children[MAX_CHILDREN];
  enum nodeType type;
  char *st;  // string representation
} Node;

typedef Node* TreeNode;


#endif
