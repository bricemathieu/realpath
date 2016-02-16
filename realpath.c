// =============================================================================
//! @file           realpath.c
//! @brief          Implementation of realpath for Mac OS X.
//! @author         Brice Mathieu
//! @copyright      Copyright (C) 2016 Brice Mathieu. All rights reserved.
//!
//! @par NAME:
//! realpath - print the resolved path.
//!
//! @par SYNOPSYS:
//! realpath FILE...
//!
//! @par DESCRIPTION:
//! Print the resolved absolute file name.
// =============================================================================

#include <stddef.h>
#include <stdlib.h>
#include <limits.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    if (argc != 2) {
        fprintf(stderr, "Usage: realpath <path>\n");
        return EXIT_FAILURE;
    }

    char resolved[PATH_MAX];
    if (realpath(argv[1], resolved) != NULL) {
        printf("%s\n", resolved);
        return EXIT_SUCCESS;
    } else {
        fprintf(stderr, "Error: %s\n", resolved);
        return EXIT_FAILURE;
    }
}
