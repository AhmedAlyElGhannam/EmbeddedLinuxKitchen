#define MWINCLUDECOLORS
#include <stdio.h>
#include <stdlib.h>
#include "nano-X.h"

int main(int ac,char **av)
{
    GR_WINDOW_ID w;
    GR_EVENT event;

    if (GrOpen() < 0) {
        printf("Can't open graphics\n");
        exit(1);
    }

    w = GrNewWindow(GR_ROOT_WINDOW_ID, 20, 20, 100, 60,
        4, WHITE, BLUE);
    GrMapWindow(w);

    for (;;) {
        GrGetNextEvent(&event);
    }
    GrClose();
    return 0;
}
