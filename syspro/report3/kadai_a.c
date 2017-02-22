#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct tnode *BTree;
struct tnode{
		int value;
		BTree left;
		BTree right;
};

BTree btree_empty()
{
		return NULL;
}

int btree_isempty(BTree t)
{
		if(t==NULL)
		{
				return 1;
		}else{
				return 0;
		}
}

BTree btree_min(BTree t)
{
		if(btree_isempty(t->left)){
				return t;
		}else{
				return btree_min(t->left);
		}
}

BTree btree_max(BTree t)
{
		if(btree_isempty(t->right)){
				return t;
		}else{
				return btree_max(t->right);
		}
}

BTree btree_create(int value, BTree t)
{
		t = malloc(sizeof(struct tnode));
    	t->value = value;
		t->left = btree_empty();
		t->right = btree_empty();

		return t;
}

BTree btree_insert(int value, BTree t)
{
		if(btree_isempty(t))
		{
				t=btree_create(value, t);
		}else{
				if(t->value==value)
				{
						t->value=value;
				}else if((t->value)>value)
				{
						if(btree_isempty(t->left))
						{
								t->left=btree_create(value, t->left);
						}else{
								t->left=btree_insert(value, t->left);
						}
				}else{
						if(btree_isempty(t->right))
						{
								t->right=btree_create(value, t->right);
						}else{
								t->right=btree_insert(value, t->right);
						}
				}
		}
		return t;
}

void btree_dump(BTree t)
{
		if(t==NULL)
		{
				printf("not found\n");
		}else{
				printf("%d\n", t->value);
		}
}

BTree btree_destroy(int value, BTree t)
{
		if(btree_isempty(t))
		{
				printf("empty");
		}else{
				if(t->value==value){
						if((btree_isempty(t->left)==1)&&(btree_isempty(t->right)==1))
						{
								t=btree_empty();
						}else if(btree_isempty(t->right)==0)
						{
								BTree min;
								min=malloc(sizeof(struct tnode));
								min=btree_min(t->right);
								t->value=min->value;
								t->right=btree_destroy(min->value, t->right);
						}else{
								BTree max;
								max=malloc(sizeof(struct tnode));
								max=btree_max(t->left);
								t->value=max->value;
								t->left=btree_destroy(max->value, t->left);
						}
				}else if((t->value)>value)
				{
						if(btree_isempty(t->left))
						{
								printf("empty left");
						}else{
								t->left=btree_destroy(value, t->left);
						}
				}else{
						if(btree_isempty(t->right))
						{
								printf("empty right");
						}else{
								t->right=btree_destroy(value, t->right);
						}
				}
		}
		return t;
}

int main()
{
		struct tnode *tree;
		tree = NULL;
		tree = btree_create(1,tree);
		tree = btree_insert(1,tree);
		tree = btree_insert(1,tree);
		tree = btree_insert(2,tree);
		btree_dump(tree);
		btree_destroy(1,tree);
		btree_dump(tree);
		return 0;
}
