#  Lamé

Lamé is a simple example of an MVVM-C application written in Swift for iOS.

### The responder chain

Lame uses the resonder chain to connect responders (eg `UIViewController`) with the coordinator which is itself a `UIResponder` (and `UIApplicationDelegate`). 

```swift
class SomeViewController: UITableViewController {
        
   weak var delegate: SomeViewControllerDelegate?
    
   private var target: SomeViewControllerDelegate? { return target(default: delegate) }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      target?.selectItem(at: indexPath)
    }
}
```

If `delegate` is set then it is used, otherwise the view controller will search up the chain until it finds a responder that conforms to `SomeViewControllerDelegate`. In our example, the root `UIResponder` is `Coordinator`.

## Gabriel Lamé

From [Wikipedia](https://en.wikipedia.org/wiki/Gabriel_Lam%C3%A9):

> **Gabriel Lamé** (22 July 1795 -- 1 May 1870) was a [French mathematician](https://en.wikipedia.org/wiki/Category:French_mathematicians "Category:French mathematicians") who contributed to the theory of [partial differential equations](https://en.wikipedia.org/wiki/Partial_differential_equation "Partial differential equation") by the use of [curvilinear coordinates](https://en.wikipedia.org/wiki/Curvilinear_coordinates "Curvilinear coordinates"), and the mathematical theory of [elasticity](https://en.wikipedia.org/wiki/Elasticity_(physics) "Elasticity (physics)") (for which [linear elasticity](https://en.wikipedia.org/wiki/Linear_elasticity "Linear elasticity") and [finite strain theory](https://en.wikipedia.org/wiki/Finite_strain_theory "Finite strain theory") elaborate the mathematical abstractions). 
>
> Lamé was born in [Tours](https://en.wikipedia.org/wiki/Tours "Tours"), in today's *département* of [Indre-et-Loire](https://en.wikipedia.org/wiki/Indre-et-Loire "Indre-et-Loire").
>
> He became well known for his general theory of [curvilinear coordinates](https://en.wikipedia.org/wiki/Curvilinear_coordinates "Curvilinear coordinates") and his notation and study of classes of ellipse-like curves, now known as [Lamé curves](https://en.wikipedia.org/wiki/Lam%C3%A9_curve "Lamé curve") or superellipses.