@doc """
    В Эликсир есть два вида чисел — целые и с плавающей точкой.

    Целые числа могут быть представлены разными способами. В разных системах исчисления: в десятичной, 
    шестнадцатеричной, восьмеричной и двоичной:

        42
        0x2A
        0o52
        0b101010

    В экспоненциальном виде:

        0.42e2

    Для больших чисел можно использовать символ подчеркивания между разрядами для удобства чтения:

        100_500
        1_000_000

    Числа с плавающей точкой реализованы по стандарту IEEE 754, как и в большинстве других языков. Это значит, 
    что их точность ограничена, и при некоторых операциях возможна потеря точности:

        0.1 + 0.2 # 0.30000000000000004

    Для целых чисел, и чисел с плавающей точкой реализованы обычные арифметические операции:

        20 + 22    # 42
        20.0 + 22  # 42.0
        50 - 8.0   # 42.0
        2 * 16     # 32
        4 * 16.0   # 64.0
        128 / 2    # 64.0
        64.0 / 4.0 # 16.0

    Операторы + - * возвращают целое число, если оба аргумента целые, и число с плавающей точкой, если хотя бы один из аргументов с плавающей точкой. Оператор / всегда возвращает число с плавающей точкой.

    Еще есть оператор целочисленного деления div и оператор взятия остатка rem:

        div(42, 2) # 21
        div(45, 2) # 22
        rem(42, 2) # 0
        rem(45, 2) # 1
"""

###### ASSIGNMENT ######
@doc """
    Реализуйте функцию do_math(a, b), которая принимает два числа, и выводит на экран:

    - результат деления суммы первого и второго числа на второе число
    - результат целочисленного деления первого числа на второе
    - остаток от деления второго числа на первое
    
    Каждый результат выводится на отдельной строке.

    Solution.do_math(10, 10)
        # => 2.0
        # => 1
        # => 0

    Solution.do_math(42, 3)
        # => 15.0
        # => 14
        # => 3
"""
defmodule Solution do
    def do_math(num1, num2) do
        IO.puts((num1 + num2) / num2)
        IO.puts(div(num1, num2))
        IO.puts(rem(num2, num1))
    end
end