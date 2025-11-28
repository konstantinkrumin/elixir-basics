@doc """
    Как было упомянуто в прошлом занятии, процессы общаются между собой с помощью сообщений. Сообщения всегда отправляются асинхронно, без подтверждения 
    доставки сообщения процессу. Чтобы получить результат обработки сообщения другим процессом, используется блокировка в ожидании ответного сообщения 
    от другого процесса, но это уже тонкости реализации синхронного вызова. По сути способ синхронизации результата это низкоуровневые детали, 
    с которыми сталкиваться скорее всего не придется. Для отправки сообщений используется функция send. Каждый процесс имеет собственный почтовый ящик, 
    который он читает с помощью функции receive. Рассмотрим на примере:
"""
send(self(), {:hello, "world"})
# => {:hello, "world"}

receive do
  {:hello, msg} -> msg
  {:world, _} -> "unmatched expression"
end
# => "world"

@doc """
    Блок кода receive при получении сообщения, проходится по всему почтовому ящику в поиске совпадений по шаблону сообщений.

    Отправка сообщений через send является неблокирующей операцией, то есть сообщения процессу отправляются асинхронно. Так как весь Elixir код выполняется в 
    каком-то процессе, то процесс может отправлять сообщения самому себе.

    Почтовые ящики у процессов могут переполняться, поэтому важно указывать базовый паттерн, в который попадут все остальные сообщения из ящика. 
    Блок receive закончит выполнение при первом совпадении паттерна, в ином случае процесс заблокируется в ожидании подходящего сообщения, либо, 
    по истечению указанного таймаута:
"""
receive do
  {:hello, msg} -> msg
after
  1_000 -> "message await stopped after 1 second"
end
# => "message await stopped after 1 second"

@doc """
    Теперь создадим отдельный процесс, который отправит сообщение в процесс родитель:
"""
parent = self()
# => #PID<0.105.0>

spawn(fn -> send(parent, {:hello, self()}) end)
# => #PID<0.6946.12>

receive do
  {:hello, pid} -> "Got hello from #{inspect(pid)}"
end
# => "Got hello from #PID<0.6946.12>"

@doc """
    Так как receive завершается по таймауту или успешной обработке сообщения, то как сделать обработку процессом сообщений постоянной? 
    Рекурсивный вызов receive, конечно же!
"""
defmodule Processor do
  def process() do
    receive do
      {:hello, msg} ->
        IO.puts(msg)
        process()

      {:world, msg} ->
        IO.puts(String.upcase(msg))
        process()

      {:exit, _} -> IO.puts("Shutdown processor...")
    end
  end
end

processor = spawn(fn -> Processor.process() end)
# => #PID<0.6952.12>
Process.alive?(processor)
# => true

send(processor, {:hello, "code basic"})
# для просмотра почтового ящика родительского процесса
# далее по коду будет подразумеваться, что эта строчка кода
# будет вызываться после каждой отправки сообщения другому процессу
Process.info(parent, :messages)
# => code basic

Process.alive?(processor)
# => true

send(processor, {:world, "code basic"})
# => CODE BASIC
Process.alive?(processor)
# => true

send(processor, {:exit, ""})
# => Shutdown processor...
Process.alive?(processor)
# => false

###### ASSIGNMENT ######
@doc """
   Создайте функцию calculate которая принимает процесс-получатель и поддерживает операции :+, :-, :* в виде сообщений от процесса и при обработке 
   возвращает сообщение процессу отправителю с результатом, функция должна поддерживать постоянную обработку сообщений. При передаче сообщения :exit, 
   функция перестает обрабатывать входящие сообщения:

    parent = self()
    calculator = spawn(fn -> Solution.calculate(parent) end)

    send(calculator, {:+, [2, 5]})
    receive do
    {:ok, result} -> result
    end
    # => 7
    Process.alive?(calculator)
    # => true

    send(calculator, {:*, [2, 5]})
    receive do
    {:ok, result} -> result
    end
    # => 10
    Process.alive?(calculator)
    # => true

    send(calculator, {:exit})
    receive do
    {:ok, result} -> result
    endz
    # => :exited
    Process.alive?(calculator)
    # => false
"""
defmodule Solution do
  def calculate(parent) do
    receive do
        {:+, [a, b]} -> 
            send(parent, {:ok, a + b})
            calculate(parent)

        {:-, [a, b]} -> 
            send(parent, {:ok, a - b})
            calculate(parent)

        {:*, [a, b]} -> 
            send(parent, {:ok, a * b})
            calculate(parent)

        {:exit} -> send(parent, {:ok, :exited})
    end
  end
end

# ALTERNATIVE SOLUTION
defmodule Solution do
  def calculate(pid) do
    receive do
      {operation, args} ->
        send(pid, {:ok, exec(operation, args)})
        calculate(pid)

      {:exit} ->
        send(pid, {:ok, :exited})
    end
  end

  defp exec(:+, [first, second]) do
    first + second
  end

  defp exec(:-, [first, second]) do
    first - second
  end

  defp exec(:*, [first, second]) do
    first * second
  end
end