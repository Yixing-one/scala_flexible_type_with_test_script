import language.experimental.captureChecking
import compiletime.uninitialized

class File:
  def write(x: String): Unit = ???

class Service:
  var file: {*} File = uninitialized
  def log = file.write("log")  // error

def withFile[T](op: (f: {*} File) => T): T =
  op(new File)

def test =
  withFile: f =>
    val o = Service()
    o.file = f
    o.log
