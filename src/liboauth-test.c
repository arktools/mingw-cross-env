/* This file is part of mingw-cross-env.       */
/* See doc/index.html for further information. */

#include <stdio.h>
#include <oauth.h>

int main (int argc, char *argv[])
{
    (void)argc;
    (void)argv;

    printf("Nonce: %s", oauth_gen_nonce());
    return (0);
}
