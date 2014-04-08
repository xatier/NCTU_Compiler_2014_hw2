#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "header.h"

#define TABLE_SIZE    256

symtab *hash_table[TABLE_SIZE];
extern int linenumber;

int HASH (char *str) {
    int idx = 0;
    while (*str) {
        idx = idx << 1;
        idx += *str;
        str++;
    }
    return (idx & (TABLE_SIZE-1));
}

/*returns the symbol table entry if found else NULL*/

symtab *lookup (char *name) {
    int hash_key;
    symtab *symptr;

    if (!name)
        return NULL;

    hash_key = HASH(name);
    symptr = hash_table[hash_key];

    while (symptr) {
        if (!(strcmp(name, symptr->lexeme)))
            return symptr;
        symptr = symptr->front;
    }
    return NULL;
}


void insertID (char *name) {
    int hash_key;
    symtab *ptr;
    symtab *symptr = (symtab *)malloc(sizeof(symtab));

    hash_key = HASH(name);
    ptr = hash_table[hash_key];

    if (ptr == NULL) {
        /*first entry for this hash_key*/
        hash_table[hash_key] = symptr;
        symptr->front = NULL;
        symptr->back = symptr;
    }
    else {
        symptr->front = ptr;
        ptr->back = symptr;
        symptr->back = symptr;
        hash_table[hash_key] = symptr;
    }

    strcpy(symptr->lexeme, name);
    symptr->line = linenumber;
    symptr->counter = 1;
}

void printSym (symtab *ptr) {
    printf("%-20s %d \n", ptr->lexeme, ptr->counter);
}

int cmpEntry (const void *a, const void *b) {
    return strcmp(((const struct symtab *)a)->lexeme,
                  ((const struct symtab *)b)->lexeme);
}

void printSymTab (void) {
    int i;
    int entry_count;

    // a copy of hash table for sorted print
    symtab *hash_table_p;

    // get entries count
    for (i = 0; i < TABLE_SIZE; i++) {
        symtab *symptr = hash_table[i];
        while (symptr != NULL) {
            symptr = symptr->front;
            entry_count++;
        }
    }

    hash_table_p = (struct symtab *)malloc(sizeof(struct symtab) * entry_count);

    int cur;
    for (i = 0, cur = 0; i < TABLE_SIZE; i++) {
        symtab *symptr = hash_table[i];
        while (symptr != NULL) {
            memcpy(&hash_table_p[cur], symptr, sizeof(struct symtab));
            symptr = symptr->front;
            cur++;
        }
    }

    // sort before printing
    qsort(hash_table_p, entry_count, sizeof(struct symtab), cmpEntry);

    printf("----- Symbol Table ---------\n");
    for (i = 0; i < entry_count; i++) {
        printSym(&hash_table_p[i]);
    }


    // be a good programmer
    free(hash_table_p);

    for (i = 0; i < TABLE_SIZE; i++) {
        symtab *symptr = hash_table[i];
        while (symptr != NULL) {
            symtab *this = symptr;
            free(this);
            symptr = symptr->front;
        }
    }
}
