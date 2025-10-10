@doc """
    Многие модули используют один и тот же общедоступный API. Рассмотрим Plug, который, как сказано в его описании, является спецификацией для 
    композитных (composable) модулей в веб-приложениях. Каждый модуль, поведение которого соответствует Plug, должен реализовать как минимум две 
    публичные функции: init/1 и call/2.

    Поведения (behaviour) предоставляют возможность:

    - определить набор функций, которые должны быть реализованы модулем;
    - гарантировать, что модуль реализует все функции из этого набора.

    По сути, поведение это как интерфейсы в объектно-ориентированных языках типа Java: набор сигнатур функций, которые должен реализовать модуль. 
    В отличие от протоколов, которые мы рассмотрим в следующем модуле, поведение не зависит от типа данных.

    Теперь определим поведение на примере. Допустим, мы хотим реализовать несколько парсеров, каждый из которых будет разбирать структурированные данные: 
    например, парсер JSON и парсер MessagePack. Каждый из этих двух парсеров будет вести себя одинаково: оба будут предоставлять функцию parse/1 и 
    функцию extensions/0. Функция parse/1 будет возвращать Elixir-представление структурированных данных, а функция extensions/0 - список расширений файлов, 
    используются для каждого типа данных (например, .json для файлов JSON).
"""
defmodule Parser do
  @doc """
  Parses a string.
  """
  @callback parse(String.t) :: {:ok, any} | {:error, atom}

  @doc """
  Lists all supported file extensions.
  """
  @callback extensions() :: [String.t]
end

@doc """
    Модули, использующие поведение Parser, должны реализовать все функции, определенные с помощью атрибута @callback. Как видно, @callback ожидает 
    не только имя функции, но и спецификацию функции, подобную той, что используется с атрибутом @spec, рассмотренные в прошлом модуле. 
    Также обратите внимание, что для представления разобранного значения используется тип any.

    Теперь реализуем описанное поведение:
"""
defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  def parse(str), do: {:ok, "parsed json " <> str}

  @impl Parser
  def extensions, do: [".json"]
end

defmodule CSVParser do
  @behaviour Parser

  @impl Parser
  def parse(str), do: {:ok, "parsed csv " <> str}

  @impl Parser
  def extensions, do: [".csv"]
end

@doc """
    Если модуль, реализующий заданное поведение, не реализует одну из функций обратного вызова (callback), требуемых этим поведением, то будет выведено 
    предупреждение на этапе компиляции.

    Кроме того, с помощью @impl можно убедиться в том, что вы реализуете правильные функции обратного вызова из заданного поведения в явном виде. 
    Например, следующий парсер реализует и parse, и extensions. Однако, из-за опечатки, BADParser реализует parse/0 вместо parse/1:
"""
defmodule BADParser do
  @behaviour Parser

  @impl Parser
  def parse, do: {:ok, "oh no"}

  @impl Parser
  def extensions, do: ["boom"]
end

@doc """
    При компиляции этого кода, компилятор выдает предупреждение о том, что реализован parse/0, а не parse/1.

    Поведения полезны тем, что можно передавать модули в качестве аргументов и затем вызывать любую из функций, указанных в поведении. 
    Например, у нас может быть функция, которая получает имя файла, и на основе его расширения вызывает соответствующий парсер:
"""
@spec parse_file(Path.t(), [module()]) :: {:ok, any} | {:error, atom}
def parse_file(filename, parsers) do
  with {:ok, ext} <- parse_extension(filename),
      {:ok, parser} <- find_parser(ext, parsers),
      {:ok, contents} <- File.read(filename) do
    parser.parse(contents)
  end
end

defp parse_extension(filename) do
  if ext = Path.extname(filename) do
    {:ok, ext}
  else
    {:error, :no_extension}
  end
end

defp find_parser(ext, parsers) do
  if parser = Enum.find(parsers, fn parser -> ext in parser.extensions() end) do
    {:ok, parser}
  else
    {:error, :no_matching_parser}
  end
end

@doc """
    Можно вызвать необходимый парсер напрямую или сделать словарь, где ключём будет нужное расширение файла, а значением нужный модуль парсера, 
    однако поведение в этом дает чуть больше гарантий, что функции модулей реализованы соответствующим образом.
"""

###### ASSIGNMENT ######
@doc """
    Реализуйте парсер, который читает текст (расширение .txt) и построчно читает его (разделитель \n). Если текст пустой, верните ошибку:

    TextParser.extensions()
    # => [".txt"]

    text = "hello\nworld!"
    TextParser.parse(text)
    # => {:ok, ["hello", "world!"]}

    text = ""
    TextParser.parse(text)
    # => {:error, :no_text}
"""
defmodule Parser do
  @doc """
  Parses a string.
  """
  @callback parse(String.t()) :: {:ok, any} | {:error, atom}

  @doc """
  Lists all supported file extensions.
  """
  @callback extensions() :: [String.t()]
end

defmodule TextParser do
  @behaviour Parser

  @impl Parser
  def parse(""), do: {:error, :no_text}

  @impl Parser
  def parse(str), do: {:ok, String.split(str, "\n")}

  @impl Parser
  def extensions, do: [".txt"]
end