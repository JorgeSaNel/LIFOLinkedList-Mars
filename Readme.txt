This file create a linked list in Mars language. It has three methods.
	
	typedef struct _node_t {
		int val; 				/* value of the node */
		struct _node_t *next; 	
	} node_t;

	node_t * push(node_t *top, int val){
		Insert elements on the list until it finds a 0
	} 
	
	node_t * Remove(node_t *top, int val){
		Remove a given element of the list if it's found
	} 
	
	void print(node_t *top){
		Print the current list
	} 