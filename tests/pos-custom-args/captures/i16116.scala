package x

import scala.annotation.*
import scala.concurrent.*

trait CpsMonad[F[_]] {
  type Context
}

object CpsMonad {
  type Aux[F[_],C] = CpsMonad[F] { type Context = C }
  given CpsMonad[Future] with {}
}

@experimental
object Test {

  @capability
  class CpsTransform[F[_]] {
     def await[T](ft: F[T]): { this } T = ???
  }

  transparent inline def cpsAsync[F[_]](using m:CpsMonad[F]) =
    new Test.InfernAsyncArg

  class InfernAsyncArg[F[_],C](using am:CpsMonad.Aux[F,C]) {
      def apply[A](expr: (CpsTransform[F], C) ?=> A): F[A] = ???
  }

  def asyncPlus[F[_]](a:Int, b:F[Int])(using cps: CpsTransform[F]): { cps } Int =
    a + (cps.await(b).asInstanceOf[Int])

  def testExample1Future(): Unit =
     val fr = cpsAsync[Future] {
        val y = asyncPlus(1,Future successful 2).asInstanceOf[Int]
        y+1
     }

}
