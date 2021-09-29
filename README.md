pp-labs-report-builder

## Содержание
* [Установка](#s-Install)
* [Запуск](#s-Launch)
* [Настройки](#s-Settings)

## <a name="s-Install"></a>Установка

Устанавливаем гит
```sh
sudo apt-get install git -y
```

Скачиваем репозиторий
```
git clone https://github.com/MyLibh/pp-labs-report-builder
```

Устанавливаем нужные пакеты
```sh
sudo bash ./requirements.sh
```

Еще нужно поставить **Latex**. Как простой, но долгий(и большой) вариант
```
sudo apt-get install texlive-full -y
```

## <a name="s-Launch"></a>Запуск

При первом запуске
```sh
chmod +x ./build.sh
```

При повторном
```sh
./build.sh
```

## <a name="s-Settings"></a>Настройки
* В файле **src/report.tex** поменять строчки __15-16__ на нужные, например
    ```
    \title{Параллельное программирование\\Лабораторная работа №1}
    \author{ИИКС ИБ\\Б19-505\\Голигузов Алексей}
    ```
* В файлах **data/analysis.tex** и **data/conclusion.tex** нужно написать анализ и заключение соответственно, например
    ```
    Алгоритм работает за $O\left(\frac{n}{N}\right)$, где $n$ - кол-во данных, $N$ - кол-во потоков.
    ```
* В файле **func.c** написать тело функции __func__ и __set_env_func__, например
    ```C
    int func(int* array, const int size, const int threads_num)
    {
        int max = array[0];

        #pragma omp parallel for num_threads(threads_num) reduction(max: max)
        for (int i = 0; i < size; ++i)
            max = array[i] > max ? array[i] : max;
    }
    ```
    ```C
    #include <omp.h>

    void set_env_func(const char* file, const char** argv)
    {
        if(!omp_get_cancellation())
        {
            putenv("OMP_CANCELLATION=true");

            execv(file, argv); // NB: Do not forget this
        }
    }
    ```