import annotation.retains
sealed trait IO:
  def puts(msg: Any): Unit = println(msg)

def test1 =
  val IO : IO @retains(caps.*) = new IO {}
  def foo = {IO; IO.puts("hello") }
  val x : () -> Unit = () => foo  // error: Found: (() -> Unit) retains IO; Required: () -> Unit

def test2 =
  val IO : IO @retains(caps.*) = new IO {}
  def puts(msg: Any, io: IO @retains(caps.*)) = println(msg)
  def foo() = puts("hello", IO)
  val x : () -> Unit = () => foo()  // error: Found: (() -> Unit) retains IO; Required: () -> Unit

type Capability[T] = T @retains(caps.*)

def test3 =
  val IO : Capability[IO] = new IO {}
  def puts(msg: Any, io: Capability[IO]) = println(msg)
  def foo() = puts("hello", IO)
  val x : () -> Unit = () => foo()  // error: Found: (() -> Unit) retains IO; Required: () -> Unit

