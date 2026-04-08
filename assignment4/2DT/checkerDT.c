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



/* see checkerDT.h for specification */
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
      proper prefix of the node's path and checks that parent is one less depth to the child and checks to see if a NULL parent node is at depth 1 */
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

   You may want to change this function's return type or
   parameter list to facilitate constructing your checks.
   If you do, you should update this function comment.
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
            fprintf(stderr, "getNumChildren claims more children than getChild returns\n");
            return FALSE;
         }

         if (Node_getParent(oNChild) != oNNode){
             fprintf(stderr, "child does not link back to parent\n");
             return FALSE;
         }
         /* Checks if the children are in lexicographic order for binary search */
         if (ulIndex > 0) {
            Node_T oNPrevChild = NULL;
            Node_getChild(oNNode, ulIndex-1, &oNPrevChild);
            if (Path_comparePath(Node_getPath(oNPrevChild), 
                     Node_getPath(oNChild)) >= 0) {
                fprintf(stderr, "Children are not in lexicographic order\n");
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

/* see checkerDT.h for specification */
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
