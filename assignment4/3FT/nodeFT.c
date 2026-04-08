/*--------------------------------------------------------------------*/
/* nodeDT.c                                                           */
/* Author: Christopher Moretti                                        */
/*--------------------------------------------------------------------*/

#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include "dynarray.h"
#include "nodeFT.h"

/* A node in a DT */
struct node {
   /* the object corresponding to the node's absolute path */
   Path_T oPPath;
   /* this node's parent */
   Node_T oNParent;
   /* the object containing links to this node's directory children 
    * | NULL if isFile is true */
   DynArray_T oDChildren;
   /* the object containing links to the node's file children
    * | NULL if isFile is true */
   DynArray_T oFChildren;
   /* void poiter to file contents | null if isFile is false */
   void * pContents;
   /* a boolean flag to indicate whether node is director or file */
   boolean isFile;
};


/*
  Links new child oNChild into oNParent's children array at index
  ulIndex. Returns SUCCESS if the new child was added successfully,
  or  MEMORY_ERROR if allocation fails adding oNChild to the array.
*/
static int Node_addChild(Node_T oNParent, Node_T oNChild,
                         size_t ulIndex, boolean isFile) {
   assert(oNParent != NULL);
   assert(oNChild != NULL);

   // if node is a directory
   if (!isFile) {
      if(DynArray_addAt(oNParent->oDChildren, ulIndex, oNChild))
         return SUCCESS;
      else
         return MEMORY_ERROR;
   }

   // if node is a file
   if(DynArray_addAt(oNParent->oFChildren, ulIndex, oNChild))
      return SUCCESS;
   else
      return MEMORY_ERROR;
}

/*
  Compares the string representation of oNfirst with a string
  pcSecond representing a node's path.
  Returns <0, 0, or >0 if oNFirst is "less than", "equal to", or
  "greater than" pcSecond, respectively.
*/
static int Node_compareString(const Node_T oNFirst,
                                 const char *pcSecond) {
   assert(oNFirst != NULL);
   assert(pcSecond != NULL);

   return Path_compareString(oNFirst->oPPath, pcSecond);
}


/*
  Creates a new node with path oPPath and parent oNParent.  Returns an
  int SUCCESS status and sets *poNResult to be the new node if
  successful. Otherwise, sets *poNResult to NULL and returns status:
  * MEMORY_ERROR if memory could not be allocated to complete request
  * CONFLICTING_PATH if oNParent's path is not an ancestor of oPPath
  * NO_SUCH_PATH if oPPath is of depth 0
                 or oNParent's path is not oPPath's direct parent
                 or oNParent is NULL but oPPath is not of depth 1
  * PARENT_IS_FILE if parent oNParent is a file
  * ALREADY_IN_TREE if oNParent already has a child with this path
*/
int Node_new(Path_T oPPath, Node_T oNParent, Node_T *poNResult,
             boolean isFile) {
   struct node *psNew;
   Path_T oPParentPath = NULL;
   Path_T oPNewPath = NULL;
   size_t ulParentDepth;
   size_t ulIndex;
   int iStatus;

   assert(oPPath != NULL);
   assert(oNParent == NULL);

   /* check parent is not a file */
   if (oNParent->isFile) {
      return PARENT_IS_FILE;
   }

   /* allocate space for a new node */
   psNew = malloc(sizeof(struct node));
   if(psNew == NULL) {
      *poNResult = NULL;
      return MEMORY_ERROR;
   }

   /* set the new node's path */
   iStatus = Path_dup(oPPath, &oPNewPath);
   if(iStatus != SUCCESS) {
      free(psNew);
      *poNResult = NULL;
      return iStatus;
   }
   psNew->oPPath = oPNewPath;

   /* validate and set the new node's parent */
   if(oNParent != NULL) {
      size_t ulSharedDepth;

      oPParentPath = oNParent->oPPath;
      ulParentDepth = Path_getDepth(oPParentPath);
      ulSharedDepth = Path_getSharedPrefixDepth(psNew->oPPath,
                                                oPParentPath);
      /* parent must be an ancestor of child */
      if(ulSharedDepth < ulParentDepth) {
         Path_free(psNew->oPPath);
         free(psNew);
         *poNResult = NULL;
         return CONFLICTING_PATH;
      }

      /* parent must be exactly one level up from child */
      if(Path_getDepth(psNew->oPPath) != ulParentDepth + 1) {
         Path_free(psNew->oPPath);
         free(psNew);
         *poNResult = NULL;
         return NO_SUCH_PATH;
      }

      /* parent must not already have child with this path */
      if(Node_hasChild(oNParent, oPPath, &ulIndex)) {
         Path_free(psNew->oPPath);
         free(psNew);
         *poNResult = NULL;
         return ALREADY_IN_TREE;
      }
   }
   else {
      /* new node must be root */
      /* can only create one "level" at a time */
      if(Path_getDepth(psNew->oPPath) != 1) {
         Path_free(psNew->oPPath);
         free(psNew);
         *poNResult = NULL;
         return NO_SUCH_PATH;
      }
   }
   psNew->oNParent = oNParent;

   /* initialize the new node */
   psNew->oDChildren = DynArray_new(0);
   if(psNew->oDChildren == NULL) {
      Path_free(psNew->oPPath);
      free(psNew);
      *poNResult = NULL;
      return MEMORY_ERROR;
   }

   /* if child is a directory */
   /* Link into parent's children list */
   if(oNParent != NULL && !isFile) {
      iStatus = Node_addChild(oNParent, psNew, ulIndex, isFile);
      if(iStatus != SUCCESS) {
         Path_free(psNew->oPPath);
         free(psNew);
         *poNResult = NULL;
         return iStatus;
      }
   }

   /* if child is a file */
   /* Link into parent's children list */
   if(oNParent != NULL && isFile) {
      iStatus = Node_addChild(oNParent, psNew, ulIndex, isFile);
      if(iStatus != SUCCESS) {
         Path_free(psNew->oPPath);
         free(psNew);
         *poNResult = NULL;
         return iStatus;
      }
   }

   *poNResult = psNew;

   assert(oNParent == NULL);

   return SUCCESS;
}

size_t Node_free(Node_T oNNode, boolean isFile) {
   size_t ulIndex;
   size_t ulCount = 0;

   assert(oNNode != NULL);

   /* remove directory child from parent's list */
   if(!isFile) {
      if(oNNode->oNParent != NULL) {
         if(DynArray_bsearch(
               oNNode->oNParent->oDChildren,
               oNNode, &ulIndex,
               (int (*)(const void *, const void *)) Node_compare)
         )
            (void) DynArray_removeAt(oNNode->oNParent->oDChildren,
                                    ulIndex);
      }

      /* recursively remove children */
      while(DynArray_getLength(oNNode->oDChildren) != 0) {
         ulCount += Node_free(DynArray_get(oNNode->oDChildren, 0), isFile);
      }
      DynArray_free(oNNode->oDChildren);
   } 
   /* remove file child from parent's list */
   else {
      if(oNNode->oNParent != NULL) {
         if(DynArray_bsearch(
               oNNode->oNParent->oFChildren,
               oNNode, &ulIndex,
               (int (*)(const void *, const void *)) Node_compare)
         )
            (void) DynArray_removeAt(oNNode->oNParent->oFChildren,
                                    ulIndex);
      }

      /* recursively remove children */
      while(DynArray_getLength(oNNode->oFChildren) != 0) {
         ulCount += Node_free(DynArray_get(oNNode->oDChildren, 0), isFile);
      }
      DynArray_free(oNNode->oFChildren);
   }

   /* remove path */
   Path_free(oNNode->oPPath);

   /* finally, free the struct node */
   free(oNNode);
   ulCount++;
   return ulCount;
}

Path_T Node_getPath(Node_T oNNode) {
   assert(oNNode != NULL);

   return oNNode->oPPath;
}

boolean Node_hasChild(Node_T oNParent, Path_T oPPath,
                      size_t *pulChildID, boolean isFile) {
   assert(oNParent != NULL);
   assert(oPPath != NULL);
   assert(pulChildID != NULL);

   // child node is a directory
   if (!isFile) {
      /* *pulChildID is the index into oNParent->oDChildren */
      return DynArray_bsearch(oNParent->oDChildren,
               (char*) Path_getPathname(oPPath), pulChildID,
               (int (*)(const void*,const void*)) Node_compareString);
   }

   // child node is a file
   /* *pulChildID is the index into oNParent->oDChildren */
   return DynArray_bsearch(oNParent->oFChildren,
            (char*) Path_getPathname(oPPath), pulChildID,
            (int (*)(const void*,const void*)) Node_compareString);
}

size_t Node_getNumChildren(Node_T oNParent) {
   assert(oNParent != NULL);

   return DynArray_getLength(oNParent->oDChildren)
            + DynArray_getLength(oNParent->oFChildren);
}

int  Node_getChild(Node_T oNParent, size_t ulChildID,
                   Node_T *poNResult, boolean isFile) {

   assert(oNParent != NULL);
   assert(poNResult != NULL);

   /* if child is a directory */
   if (!isFile) {
      /* ulChildID is the index into oNParent->oDChildren */
      if(ulChildID >= Node_getNumChildren(oNParent)) {
         *poNResult = NULL;
         return NO_SUCH_PATH;
      }
      else {
         *poNResult = DynArray_get(oNParent->oDChildren, ulChildID);
         return SUCCESS;
      }
   }
   /* if child is a file */
   else {
      /* ulChildID is the index into oNParent->oDChildren */
      if(ulChildID >= Node_getNumChildren(oNParent)) {
         *poNResult = NULL;
         return NO_SUCH_PATH;
      }
      else {
         *poNResult = DynArray_get(oNParent->oFChildren, ulChildID);
         return SUCCESS;
      }
   }
}

Node_T Node_getParent(Node_T oNNode) {
   assert(oNNode != NULL);

   return oNNode->oNParent;
}

int Node_compare(Node_T oNFirst, Node_T oNSecond) {
   assert(oNFirst != NULL);
   assert(oNSecond != NULL);

   return Path_comparePath(oNFirst->oPPath, oNSecond->oPPath);
}

char *Node_toString(Node_T oNNode) {
   char *copyPath;

   assert(oNNode != NULL);

   copyPath = malloc(Path_getStrLength(Node_getPath(oNNode))+1);
   if(copyPath == NULL)
      return NULL;
   else
      return strcpy(copyPath, Path_getPathname(Node_getPath(oNNode)));
}
