@doc """
    Конструкторы списков являются еще одним способом работы с коллекциями, помимо классических map, filter, reduce.
"""
# пример map
users = [%{name: "Igor", age: 21}, %{name: "John", age: 13}, %{name: "Alice", age: 20}, %{name: "Isabella", age: 13}]

for %{name: name, age: age} <- users, do: "Name: #{name}, age: #{age}"
# => ["Name: Igor, age: 21", "Name: John, age: 13", "Name: Alice, age: 20", "Name: Isabella, age: 13"]

# пример filter
for %{age: age} = user <- users, age > 15, do: user
# => [%{age: 21, name: "Igor"}, %{age: 20, name: "Alice"}]

# комбинация map и filter
for %{name: name, age: age} <- users, age < 15, do: name
# => ["John", "Isabella"]

@doc """
    Конструкторы списков могут обрабатывать несколько списков одновременно:
"""
list1 = [1, 2, 3]
list2 = [:a, :b, :c]

for x <- list1, y <- list2, do: {x, y}
# => [
# => {1, :a},
# => {1, :b},
# => ...
# => {3, :b},
# => {3, :c}
# => ]

@doc """
    Элементы списков соединяются "каждый с каждым".

    Коллекция может быть любой структурой данных, реализующей протокол Enumerable. Каждый элемент коллекции сопоставляется с шаблоном, и если 
    не происходит совпадения, то этот элемент отбрасывается
"""
# пример map
users = [%{name: "Igor"}, %{name: "John", age: 13}, %{name: "Alice"}, %{name: "Isabella", age: 13}]

for %{name: name, age: age} <- users, do: "Name: #{name}, age: #{age}"
# => ["Name: John, age: 13", "Name: Isabella, age: 13"]

@doc """
    В конструктор списков можно передать опцию into, которая позволяет добавить результат генератора списка в существующую коллекцию.
"""
result = %{a: 1, b: 2}

for {k, v} <- [{:c, 3}, {:d, 4}, {:name, "Igor"}], into: result, do: {k, v}
# => %{a: 1, b: 2, c: 3, d: 4, name: "Igor"}

###### ASSIGNMENT ######
@doc """
    Создайте функцию fetch_gamers, которая принимает список сотрудников и выводит список активных сотрудников (статус :active) сотрудников у которых 
    хобби связаны с играми (тип хобби :gaming). Структура сотрудников описана в примере:
    
    employees = [
        %{
            name: "Eric",
            status: :active,
            hobbies: [%{name: "Text Adventures", type: :gaming}, %{name: "Chickens", type: :animals}]
        },
        %{
            name: "Mitch",
            status: :former,
            hobbies: [%{name: "Woodworking", type: :making}, %{name: "Homebrewing", type: :making}]
        },
        %{
            name: "Greg",
            status: :active,
            hobbies: [
            %{name: "Dungeons & Dragons", type: :gaming},
            %{name: "Woodworking", type: :making}
            ]
        }
    ]


    Solution.fetch_gamers(employees)
    # => [
    # =>   {"Eric", %{name: "Text Adventures", type: :gaming}},
    # =>   {"Greg", %{name: "Dungeons & Dragons", type: :gaming}}
    # => ]
"""
defmodule Solution do
  def fetch_gamers(employees) do
    for %{name: name, status: :active, hobbies: hobbies} <- employees, hobby <- hobbies, hobby.type == :gaming, do: {name, hobby}
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  def fetch_gamers(employees) do
    for employee <- employees,
        employee.status == :active,
        hobby <- employee.hobbies,
        hobby.type == :gaming do
      {employee.name, hobby}
    end
  end
end