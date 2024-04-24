@doc """
    Булевый тип в Эликсир представлен значениями true и false. Но еще в языке есть 
    nil — специальное значение выражающее отсутствие информации.

    Двоичная логика представлена операторами and, or, not. Это "строгие" операторы, 
    они работают только со значениями true и false:
"""
true and true  # true
true and false # false
true or true   # true
true or false  # true
not true       # false
not false      # true

@doc """
    Так же есть операторы &&, ||, !. Их называют "смягченными" (relaxed) операторами, потому что 
    в отличие от строгих, они принимают любые значения. При этом все значения, кроме false и nil 
    интерпретируются как true:
"""
42 && true   # true
false && nil # false
true || 42   # true
true || nil  # true
! nil        # true
! 42         # false

@doc """
    Оператор && в успешном случае возвращает свой второй аргумент, в неуспешном случае возвращает 
    неуспешный аргумент:
"""
true && 42  # успешно, второй аргумент, 42
42 && true  # успешно, второй аргумент, true
false && 42 # не успешно, false
nil && 42   # не успешно, nil
42 && nil   # не успешно, nil

# Есть еще варианты:
false && nil # false
nil && false # nil

# Но можно не запоминать их, так как на практике это не так важно.

# Оператор || в успешном случае возвращает успешный аргумент:
42 || false  # 42
false || 42  # 42
nil || false # false
false || nil # nil

# Оператор ! возвращает true или false при любых аргументах:
! 42    # false
! true  # false
! false # true
! nil   # true

@doc """
    В английской терминологии в контексте этих операторов значения false и nil называют falsy, а 
    все остальные значения называют truthy. В буквальном переводе это значит "фальшивый" и "правдивый".

    И строгие, и смягченные операторы являются ленивыми. То есть, они вычисляют только часть выражения, 
    если этого достаточно:
"""
IO.puts("a") && IO.puts("b") # => a b
IO.puts("a") || IO.puts("b") # => a
true or IO.puts("b")         # true
false and IO.puts("b")       # false

# Некоторые разработчики используют их для вывода сообщения об ошибке в случае неуспешной операции:
do_something() || IO.puts("error")


###### ASSIGNMENT ######
@doc """
    Реализуйте функцию any?(a, b, c, d), которая принимает четыре булевых аргумента, и возвращает true, если среди 
    аргументов есть true.

    Реализуйте функцию truthy?(a, b), которая принимает два аргумента любого типа, и если первый аргумент truthy, 
    то функция возвращает второй аргумент.

    Solution.any?(false, false, false, false) # => false
    Solution.any?(true, false, false, false) # => true
    Solution.any?(false, true, false, true) # => true

    Solution.truthy?(true, 42) # => 42
    Solution.truthy?("hello", false) # => false
    Solution.truthy?("", nil) # => nil
"""
defmodule Solution do
    def any?(a, b, c, d) do 
        a or b or c or d
    end

    def truthy?(a, b) do 
        a && b
    end
end