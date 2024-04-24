@doc """
    В эликсире функции группируются по модулям, которые выполняют роль неймспейсов. Например, в предыдущем уроке мы 
    использовали функцию puts(text) из модуля IO:
"""

# Обращение по имени не зависит от того, в каком месте программы происходит вызов
IO.puts("Hello, World!")

# Модули определяются с помощью конструкции defmodule/do/end:

# Имя записывается в CamelCase
defmodule HexletBasics do
  # Здесь описывается содержимое модуля
end

@doc """
    Эликсир позволяет создавать несколько модулей в одном файле, но так делают не часто. Обычно, создают один модуль 
    на один файл. Имя этого файла получается из имени модуля переводом его CamelCase в snake_case.

    Модули могут быть вложенными. Как правило, их помещают внутри директорий относительно базовой директории проекта. 
    Например, в коде этого сайта есть модуль HexletBasics.Application, который расположен в директории 
    lib/hexlet_basics/application.ex.
"""
defmodule HexletBasics.Application do
  # Функция
  def hello do
    IO.puts("Hello, World!")
  end
end

@doc """
    Обращение к функциям вложенных модулей ничем не отличается от обращения к плоским модулям. Сначала указывается 
    полное имя модуля, за которым идет вызов функции
"""
HexletBasics.Application.hello()

@doc """
    Один модуль встроенный в Эликсир является особенным. Это модуль Kernel. Функции этого модуля можно вызывать 
    напрямую, без указания самого модуля:
"""
is_number(13) # true

@doc """
    Kernel содержит базовые языковые примитивы для арифметических операций, порождения процессов, определения новых 
    функций и модулей, обработки типов данных и так далее.
"""

#########################
defmodule My.Super.Module do 
    def hello do
        IO.puts("Hello, World!")
    end
end