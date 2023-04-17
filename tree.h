#ifndef __TREE_H__
#define __TREE_H__

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_CHILDREN 32



enum nodeType {
  DECLARATION,
  STATEMENT,
  DEFAULTNODE
};

typedef enum nodeType NodeType;

typedef struct _node {
  struct _node *children[MAX_CHILDREN];
  enum nodeType type;
  char *st;  // string representation
  char isTerminal;
} Node;

#define addChild(x, y) _Generic(y, Node*: addChildn, char*: addChilds)(x, y)

typedef Node* TreeNode;

Node* createNode(char*);

void addChildn(Node*, Node*);
void addChilds(Node*, char*);

#endif