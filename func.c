#include <unistd.h>

void set_env_func(const char* file, const char** argv)
{
    if (0)
    {
        exec(file, argv);
    }
}

void func(int* array, const int size, const int threads_num)
{
    int max = array[0];
    
    #pragma omp parallel for num_threads(threads_num) reduction(max: max)
    for (int i = 0; i < size; ++i)
        max = array[i] > max ? array[i] : max;
}
