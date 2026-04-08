/*--------------------------------------------------------------------*/
/* checkerDT.c                                                        */
/* Author: Sergei Kudriavtcev, Joshua (Kimyung) Song                  */
/*--------------------------------------------------------------------*/

#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "checkerDT.h"
#include "dynarray.h"
#include "path.h"



/* 
   See checkerDT.h for further specification. 
   Checks whether node oNNode satisfies all invariants by verifying
   that the node is non-NULL, that its parent-child path relationship
   is structurally correct, and that root nodes are the only nodes
   allowed to have no parent.
*/
boolean CheckerDT_Node_isValid(Node_T oNNode) {
   Node_T oNParent;
   Path_T oPNPath;
   Path_T oPPPath;

   /* Sample check: a NULL pointer is not a valid node */
   if(oNNode == NULL) {
      fprintf(stderr, "A node is a NULL pointer\n");
      return FALSE;
   }

   /* parent's path must be the longest possible
      proper prefix of the node's path and checks that parent is one
      less depth to the child and checks to see if a NULL parent node
      is at depth 1 */
   oNParent = Node_getParent(oNNode);
   if(oNParent != NULL) {
      oPNPath = Node_getPath(oNNode);
      oPPPath = Node_getPath(oNParent);

      if(Path_getSharedPrefixDepth(oPNPath, oPPPath) !=
         Path_getDepth(oPNPath) - 1) {
         fprintf(stderr, "P-C nodes don't have P-C paths: (%s) (%s)\n",
                 Path_getPathname(oPPPath), Path_getPathname(oPNPath));
         return FALSE;
      }

      if ((Path_getDepth(oPPPath)+1) != Path_getDepth(oPNPath)) {
          fprintf(stderr, "Parent depth is not one less than child depth\n");
          return FALSE;
      }

      
   } else if (Path_getDepth(Node_getPath(oNNode))!= 1){
           fprintf(stderr, "Node has no parent but NOT at depth 1\n");
           return FALSE;

   } 


   return TRUE;
}

/*
   Performs a pre-order traversal of the tree rooted at oNNode.
   Returns FALSE if a broken invariant is found and
   returns TRUE otherwise.

   For every reachable node, this function:
   * incrememnts *pulCount
   * checks that the node itself is valid
   * checks that each child can be retrieved successfully
   * checks that each child points to oNNode as its parent
   * checks that children are stored in increasing lexographic order
*/
static boolean CheckerDT_treeCheck(Node_T oNNode, size_t *pulCount) {
   size_t ulIndex;

   if(oNNode!= NULL) {
       (*pulCount)++;

      /* Sample check on each node: node must be valid */
      /* If not, pass that failure back up immediately */
      if(!CheckerDT_Node_isValid(oNNode))
         return FALSE;

      /* Recur on every child of oNNode */
      for(ulIndex = 0; ulIndex < Node_getNumChildren(oNNode); ulIndex++)
      {
         Node_T oNChild = NULL;
         int iStatus = Node_getChild(oNNode, ulIndex, &oNChild);

         if(iStatus != SUCCESS) {
            fprintf(stderr,
               "getNumChildren claims more children than getChild\n");
            return FALSE;
         }

         if (Node_getParent(oNChild) != oNNode){
             fprintf(stderr, "child does not link back to parent\n");
             return FALSE;
         }
         /* Checks if the children are in lexicographic order for binary
            search */
         if (ulIndex > 0) {
            Node_T oNPrevChild = NULL;
            Node_getChild(oNNode, ulIndex-1, &oNPrevChild);
            if (Path_comparePath(Node_getPath(oNPrevChild), 
                     Node_getPath(oNChild)) >= 0) {
                fprintf(stderr,
                        "Children are not in lexicographic order\n");
                return FALSE;
        }
    }


         /* if recurring down one subtree results in a failed check
            farther down, passes the failure back up immediately */
         if(!CheckerDT_treeCheck(oNChild, pulCount))
            return FALSE;
      }
   }
   return TRUE;
}

/* 
   See checkerDT.h for specification.
   Checks whether the entire DT satisfies global invariants by
   verifying initialization/count consistency via boolean
   bIsInitialized, recursively validating reachable nodes in the
   tree starting at root node oNRoot, checking each child links back
   to its parent, checking children remain in lexicographic order, and
   ensuring the total number of reachable nodes matches ulCount.
*/
boolean CheckerDT_isValid(boolean bIsInitialized, Node_T oNRoot,
                          size_t ulCount) {

    size_t nodeCount = 0;

   /* Sample check on a top-level data structure invariant:
      if the DT is not initialized, its count should be 0. */
   if(!bIsInitialized)
      if(ulCount != 0) {
         fprintf(stderr, "Not initialized, but count is not 0\n");
         return FALSE;
      }

   /* Now checks invariants recursively at each node from the root. */
   /*return CheckerDT_treeCheck(oNRoot, size_t *pulCount);*/
   if(!CheckerDT_treeCheck(oNRoot, &nodeCount)){
    return FALSE;
   }

   /* Check to make sure node count matches the ulCount */
    if(nodeCount != ulCount) {
        fprintf(stderr, "ulCount does not match actual node count\n");
        return FALSE;
    }
    return TRUE;
}
