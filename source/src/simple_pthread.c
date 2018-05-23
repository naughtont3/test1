#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

void *foo_fn (void *ptr)
{
    char *msg;
    msg = (char *) ptr;
    printf("[%05d] %s\n", getpid(), msg);
    printf("[%05d] mytid is %lu\n", getpid(), (unsigned long)pthread_self());
    return 0;
}

int main(int argc, char **argv)
{
    int rc;
    pthread_t thread;

    rc = pthread_create (&thread, NULL,  foo_fn, "hello-from-foo");
    if (0 != rc) {
        fprintf (stderr, "Error: pthread_create() failed\n");
    }

    printf("[%05d] mytid is %lu\n", getpid(), (unsigned long)pthread_self());

    printf("[%05d] Hello from %s():line %d\n", 
            getpid(), __FUNCTION__, __LINE__);


    rc = pthread_join (thread, NULL);
    if (0 != rc) {
        fprintf (stderr, "Warning: pthread_join() failed\n");
    }

    printf("[%05d] Done.\n", getpid());
    return (EXIT_FAILURE);
}
