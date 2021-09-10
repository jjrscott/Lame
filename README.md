#  Lamé

Lamé is a simple example of an MVVM-C application written in Swift for iOS. It has **zero** external dependencies so should function fresh out of the box.

### The responder chain

Lame uses the responder chain to connect responders (e.g. `UIViewController`) with the coordinator which is itself a `UIResponder` (and `UIApplicationDelegate`). This functionality is implemented via `UIResponderDelegate` along with its associated default implementation

```swift
class SomeViewController: UITableViewController, UIResponderDelegate {
        
   weak var delegate: SomeViewControllerDelegate?
       
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      target?.selectItem(at: indexPath)
    }
}
```

If `delegate` is set, then it is used; otherwise, the view controller will search up the chain until it finds a responder that conforms to `SomeViewControllerDelegate`. In our example, the root `UIResponder` is `Coordinator`.

### Segues

Apple encourages the use of storyboards but keeping the flow out of view controllers is made almost impossible by the existence of `UIViewController.prepare(for:sender:)`.

However, back in the ObjC days, I used runtime magic and the knowledge that the whole process happens on the main thread to produce `performSegue(withIdentifier:prepare:)` which allows you to handle the preparation in the same code `performSegue` is called. In our case, the coordinator.

### ResultSemaphore

`ResultSemaphore` extends `Result` across multiple threads to pass data from inside a block (say a network response) to the code waiting for it (say a network test). Note how we can mix the two to produce code like:

```swift
client.requestTrending(result: semaphore.signal)
```

Very tidy.

## Bugs

Every real project has bugs that miss the ship date. As Lame is designed to be a good example, it has bugs too. (At least that's my story, and I'm probably not going to stick to it). Take a look at "[Poster images not appearing](https://github.com/jjrscott/Lame/issues/1)" for a cracking example.

## Gabriel Lamé

From [Wikipedia](https://en.wikipedia.org/wiki/Gabriel_Lam%C3%A9):

> **Gabriel Lamé** (22 July 1795 -- 1 May 1870) was a [French mathematician](https://en.wikipedia.org/wiki/Category:French_mathematicians "Category:French mathematicians") who contributed to the theory of [partial differential equations](https://en.wikipedia.org/wiki/Partial_differential_equation "Partial differential equation") by the use of [curvilinear coordinates](https://en.wikipedia.org/wiki/Curvilinear_coordinates "Curvilinear coordinates"), and the mathematical theory of [elasticity](https://en.wikipedia.org/wiki/Elasticity_(physics) "Elasticity (physics)") (for which [linear elasticity](https://en.wikipedia.org/wiki/Linear_elasticity "Linear elasticity") and [finite strain theory](https://en.wikipedia.org/wiki/Finite_strain_theory "Finite strain theory") elaborate the mathematical abstractions). 
>
> Lamé was born in [Tours](https://en.wikipedia.org/wiki/Tours "Tours"), in today's *département* of [Indre-et-Loire](https://en.wikipedia.org/wiki/Indre-et-Loire "Indre-et-Loire").
>
> He became well known for his general theory of [curvilinear coordinates](https://en.wikipedia.org/wiki/Curvilinear_coordinates "Curvilinear coordinates") and his notation and study of classes of ellipse-like curves, now known as [Lamé curves](https://en.wikipedia.org/wiki/Lam%C3%A9_curve "Lamé curve") or superellipses.