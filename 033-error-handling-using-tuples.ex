@doc """
    Как было описано в прошлом упражнении, в Elixir не используют исключения напрямую для обработки ошибок и управлением работы программы. 
    Вместо этого из функций возвращают кортежи, если операция была успешна, то {:ok, result}, где result - результат выполнения функции. 
    В случае ошибки возвращается кортеж вида {:error, reason} - где reason причина ошибки, может быть любого формата. Рассмотрим примеры:
"""
File.copy("/not_existing_dir",  "/existing_dir")
# => {:error, :enoent}
File.copy("/some_dir",  "/existing_dir")
# => {:ok, 210}

@doc """
    Важно отметить, что для булевых функций, лучше возвращать не кортеж, а true или false.

    При таком подходе к обработке ошибок, органично использовать паттерн-матчинг:
"""
defmodule Example do
  @magic_number 10

  def multiply_by_two(number) when is_integer(number) do
    {:ok, number * 2}
  end

  def multiply_by_two(number) do
    {:error, :not_number}
  end

  def magic(number) do
    case multiply_by_two(number) do
      {:ok, result} -> {:ok, result + @magic_number}
      {:error, reason} -> {:error, :no_magic_here}
    end
  end
end

Example.multiply_by_two(2)
# => {:ok, 4}
Example.multiply_by_two("string")
# => {:error, :not_number}

Example.magic(2)
# => {:ok, 14}
Example.magic("string")
# => {:error, :no_magic_here}

@doc """
    Для простых функций не обязательно возвращать кортеж {:ok, result}, достаточно вернуть только result. Однако если функция в разных условиях возвращает 
    разный результат, например, словарь с разным набором ключей, тогда лучше использовать кортежи и точнее паттерн-матчить их.
"""

###### ASSIGNMENT ######
@doc """
   Реализуйте функцию compare, которая сравнивает два переданных числа:

   Solution.compare(2, 3)
   # => {:ok, :less}
   Solution.compare(3, 3)
   # => {:ok, :equal}
   Solution.compare(4, 3)
   # => {:ok, :greater}

   Solution.compare("", 3)
   # => {:error, :not_number}
   Solution.compare(2, [])
   # => {:error, :not_number}
"""
defmodule Solution do
  def compare(num1, num2) when is_integer(num1) and is_integer(num2) do
    cond do
        num1 > num2 -> {:ok, :greater}
        num1 == num2 -> {:ok, :equal}
        num1 < num2 -> {:ok, :less}
    end
  end

  def compare(_num1, _num2) do
    {:error, :not_number}
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  def compare(first, _) when not is_integer(first), do: {:error, :not_number}
  def compare(_, second) when not is_integer(second), do: {:error, :not_number}

  def compare(first, second) do
    cond do
      first == second -> {:ok, :equal}
      first < second -> {:ok, :less}
      first > second -> {:ok, :greater}
    end
  end
end