#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

#ifndef TESTS_NUM
#define TESTS_NUM 10
#endif /* !TESTS_NUM */

#ifndef MAX_THREADS_NUM
#define MAX_THREADS_NUM 16
#endif /* !MAX_THREADS_NUM */

extern void func(int* array, const int size, const int threads_num);
extern void set_env_func(const char* file, const char* argv[]);

int main(int argc, const char* argv[])
{
    set_env_func(argv[0], argv);

    printf("OpenMP version: %d\n Number of tests: %d, max threads number: %d\n", _OPENMP, TESTS_NUM, MAX_THREADS_NUM);

    const int size = 1e8;
    int* array = (int*)malloc(size * sizeof(int));
    if (!array)
    {
        fprintf(stderr, "[ERROR] Cannot allocate space for the array\n");

        return 1;
    }

    for (int i = 0; i < TESTS_NUM; ++i)
    {
        srand(time(NULL));

        for (int j = 0; j < size; ++j)
            array[j] = rand();

        for (int threads_num = 1; threads_num <= MAX_THREADS_NUM; ++threads_num)
        {
            double start = omp_get_wtime(); 
            func(array, size, threads_num);
            double end = omp_get_wtime(); 

            printf("Test #%d threads_num: %2d time: %fs\n", i + 1, threads_num, end - start);
        }
    }

    free(array);

    return 0;
}
